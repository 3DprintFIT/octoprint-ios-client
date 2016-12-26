//
//  BrowseBonjourOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation

/// Browse local Bonjour services
class BrowseBonjourOperation: BaseOperation {

    /// Bonjour service type
    private static let serviceType = "_workstation._tcp"

    /// Bonjour service domain
    private static let serviceDomain = "local."

    /// Bonjour service browser
    private let serviceBrowser = NetServiceBrowser()

    /// Currently reachable services
    var services = Set<NetService>()

    /// Creates new instance of domain browser,
    /// but does not start browsing immediately
    override init() {
        super.init()

        serviceBrowser.delegate = self
    }

    /// Starts domain browsing
    override func start() {
        print("Staring operation: \(classForCoder)")

        serviceBrowser.schedule(in: .current, forMode: .defaultRunLoopMode)
        serviceBrowser.searchForServices(
            ofType: BrowseBonjourOperation.serviceType,
            inDomain: BrowseBonjourOperation.serviceDomain
        )
    }

    /// Takes care of operation finish
    fileprivate func finish() {
        serviceBrowser.delegate = nil
        serviceBrowser.stop()
        isFinished = true
    }
}

extension BrowseBonjourOperation: NetServiceBrowserDelegate {

    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didNotSearch errorDict: [String : NSNumber]
    ) {
        finish()
    }

    public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        finish()
    }

    public func netServiceBrowser(
        _ browser: NetServiceBrowser,
        didFind service: NetService,
        moreComing: Bool
    ) {
        services.insert(service)

        if !moreComing {
            finish()
        }
    }

    public func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {

    }

    public func netServiceBrowser(_ browser: NetServiceBrowser,
                                  didRemoveDomain domainString: String, moreComing: Bool) {

        finish()
    }

    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        finish()
    }
}
