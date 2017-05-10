//
//  Bonjour.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift

/// Bonjour service browser wrapper. Searches for all available services in
/// given domain and resolves their IPs.
///
/// The service first find all services, once the system tells there are no other services,
/// the IPs are getting resolved one by one.
/// Each time the service gets resolved, the value is sent to producer.
///
/// Before IPs are resolved, the system first have to resolve service it's address.
/// Once the address is known, the IP is beeing resolved.
///
/// Note: Only one search may be done at the time. So if you start the new one,
/// the old one will be interrupted. Therefor the Bonjour is implemented as singleton.
///
/// Note: Only errors from system are send to signal, IP resolving errors are thrown away.
class Bonjour: NSObject {

    /// Supported searchable domains
    ///
    /// - local: Local domain
    enum Domain: String {
        case local = "local."
    }

    /// Available service types
    ///
    /// - workstation: Workgroup
    /// - all: Is not actual service but search for service groups
    /// - httpTransfer: HTTP connections
    /// - linePrinter: LPR printers
    /// - internetPrinter: Internet printers on HTTP
    /// - remoteUSBPrinter: Remote USB printers
    enum ServiceType: String {
        case workstation = "_workstation._tcp."
        case all = "_services._dns-sd._udp."
        case httpTransfer = "_http._tcp."
        case linePrinter = "_printer._tcp."
        case internetPrinter = "_ipp._tcp."
        case remoteUSBPrinter = "_riousbprint._tcp."
    }

    /// The actual network browser
    private let browser = NetServiceBrowser()

    /// Services found on the network which are not resolved yet
    fileprivate var foundServices = [NetService]()

    /// Services which IPs were resolved successfully
    fileprivate var resolvedServices = [BonjourService]()

    /// Signal sink
    fileprivate var sink: Observer<[BonjourService], NetService.ErrorCode>?

    /// The singleton instance
    private static let shared = Bonjour()

    /// Starts new search for services of given type in domain.
    /// If there is currently another searching running, it will be interrupted.
    ///
    /// - Parameters:
    ///   - type: Type of service which will be searched
    ///   - domain: Domain where the services will be searched
    /// - Returns: New signal sending collection of resolved services
    static func searchForServices(ofType type: ServiceType = .workstation,
                                  inDomain domain: Domain = .local) -> Signal<[BonjourService], NetService.ErrorCode> {

        shared.stop()

        let (signal, sink) = Signal<[BonjourService], NetService.ErrorCode>.pipe()

        shared.sink = sink

        shared.browser.delegate = shared
        shared.browser.searchForServices(ofType: type.rawValue, inDomain: domain.rawValue)

        return signal
    }

    /// Resolves next service from stack or complete the signal if stack is empty
    fileprivate func resolveNext() {
        // The service must not be popped or it's deallocated and not correctly resolved.
        guard let service = foundServices.last else {
            sink?.sendCompleted()
            return
        }

        service.delegate = self
        service.resolve(withTimeout: 2)
    }

    /// Resolves service IP address. The service must have resolved addresses by system
    /// before IP can be resolved.
    ///
    /// - Parameter service: Service to be resolved.
    /// - Returns: BonjourService if service is resolved correctly, false otherwise.
    fileprivate func resolveIP(for service: NetService) -> BonjourService? {
        // Create empty hostname for C operations
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

        // If address is not resolved correctly stop IP resolving
        guard let address = service.addresses?.first else { return nil }

        // If address can not be converted to IP, return nil
        guard address.withUnsafeBytes({ (pointer: UnsafePointer<sockaddr>) in
            return getnameinfo(pointer, socklen_t(address.count), &hostname, socklen_t(hostname.count),
                               nil, 0, NI_NUMERICHOST) == 0
        }) else {
            return nil
        }

        let ip = String(cString: hostname)

        // The service was resolved successfully
        return BonjourService(name: service.name, address: ip, port: "\(service.port)")
    }

    /// Unwraps system error or return .unknownError if it can not be unwrapped.
    ///
    /// - Parameter errorDict: System error representation
    /// - Returns: Error which occured or .unknownError
    fileprivate func unwrapError(fromDictionary errorDict: [String: NSNumber]) -> NetService.ErrorCode {
        guard
            let code = errorDict.first,
            let error = NetService.ErrorCode(rawValue: code.1.intValue)
        else {
            // Fallback when error could not be unwrapped
            return .unknownError
        }

        return error
    }

    /// Stops all active services, free all resources
    private func stop() {
        sink?.sendInterrupted()
        foundServices.removeAll()
        resolvedServices.removeAll()
        browser.stop()
    }
}

// MARK: - NetServiceBrowserDelegate
/// Browser delegate takes care of found services.
/// Once the searching is over, it starts the address and IP resolving.
extension Bonjour: NetServiceBrowserDelegate {
    // An error occured while seraching for services
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        let error = unwrapError(fromDictionary: errorDict)

        sink?.send(error: error)
    }

    // New service found (not yet resolved)
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        foundServices.append(service)

        if !moreComing {
            // When the last service was found, start resolving addresses
            resolveNext()
        }
    }
}

// MARK: - NetServiceDelegate
/// Delegate for service address resolving.
/// Once address is resolved, the IP is beeing reconstructed.
/// Only one service is resolved at the time.
extension Bonjour: NetServiceDelegate {
    // The service address was resolved
    func netServiceDidResolveAddress(_ service: NetService) {
        // The original service is not needed anymore and can be removed
        if let index = foundServices.index(of: service) {
            foundServices.remove(at: index)
        }

        // Try to resolve IP from address
        if let service = resolveIP(for: service) {
            resolvedServices.append(service)
            sink?.send(value: resolvedServices)
        }

        // Take another from stack
        resolveNext()
    }

    // Resolve of service address failed
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        let error = unwrapError(fromDictionary: errorDict)

        sink?.send(error: error)
    }
}

// Adds confrontance to error protocol to error code to be able to use
// it's value in signal.
extension NetService.ErrorCode: Error { }
