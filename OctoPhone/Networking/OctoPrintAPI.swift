//
//  OctoPrintAPI.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Moya

typealias Parameters = [String: Any]
typealias OctoPrintProvider = DynamicProvider<OctoPrintAPI>

/// Targets definition
///
/// - version: OctoPrint API version
/// - sendCommand: Sends arbitrary command to printer
/// - files: Downloads list of stored files on printer
enum OctoPrintAPI {
    // Command
    case version
    // Printer
    case sendCommand(String)
    // Files
    case files
    // Logs
    case logs
    case downloadLog(String)
}

// MARK: - TargetPart implementation
// Implements Moya protocol for creating Endpoints from Targets
extension OctoPrintAPI: TargetPart {
    var path: String { return requestData.path }

    var method: Moya.Method { return requestData.method }

    var parameters: Parameters? { return requestData.parameters }

    var parameterEncoding: ParameterEncoding { return Moya.JSONEncoding.default }

    var sampleData: Data {
        switch self {
        case .version: return stubbedResponse("Version")
        case .sendCommand: return stubbedResponse("SendCommand")

        default: return Data()
        }
    }

    var task: Task { return requestData.task }

    var validate: Bool { return false }

    /// Target to endpoint data maping
    var requestData: (path: String, method: Moya.Method, task: Task, parameters: Parameters?) {
        switch self {
        // Common
        case .version: return ("api/version", .get, .request, nil)
        // Printer
        case let .sendCommand(command): return ("api/printer/command", .get, .request, ["command": command])
        // Files
        case .files: return ("api/files", .get, .request, nil)
        // Logs
        case .logs: return ("api/logs", .get, .request, nil)
        case let .downloadLog(logName):
            return ("downloads/logs/\(logName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")",
                .get,
                .download(.request(DefaultDownloadDestination)),
                nil
            )
        }
    }
}

// swiftlint:disable variable_name
/// Default file download destination for Moya requests
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    if !directoryURLs.isEmpty {
        return (directoryURLs[0].appendingPathComponent(response.suggestedFilename!), [])
    }

    return (temporaryURL, [])
}
// swiftlint:enable variable_name

/// Reads data for stubbed data
///
/// - Parameter fileName: Name of resource with stabbed data
/// - Returns: Data representation of stored resource
//swiftlint:disable force_try
fileprivate func stubbedResponse(_ fileName: String) -> Data {
    let path = Bundle(for: AppDelegate.self).path(forResource: fileName, ofType: "json")

    return try! Data(contentsOf: URL(fileURLWithPath: path!))
}
//swiftlint:enable force_try
