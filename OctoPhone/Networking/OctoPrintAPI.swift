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

/// argets declaration
///
/// - version: OctoPrint API version
/// - sendCommand: Sends arbitrary command to printer
/// - files: Downloads list of stored files on printer
/// - logs: Downloads list of list
/// - downloadLog: Downloads log file to internal sotrage
/// - deleteLog: Deletes specified log
/// - slicers: Downloads list of installed slicers
/// - slicerProfiles: Downloads list of slicing profiles fro given slicer
/// - deleteSlicingProfile: Deletes given slicing profile from printer
/// - printProfiles - Downloads list of installed print profiles
/// - updatePrinterProfile - Updates existing printer profile
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
    case deleteLog(String)
    // Slicers
    case slicers
    case slicerProfiles(String)
    case deleteSlicingProfile(slicerID: String, profileID: String)
    // Printer profiles
    case printerProfiles
    case updatePrinterProfile(profileID: String, data: Parameters)
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
            return ("downloads/logs/\(logName.urlEncoded)", .get, .download(.request(DefaultDownloadDestination)), nil)
        case let .deleteLog(logName):
            return ("api/logs/\(logName.urlEncoded)", .delete, .request, nil)
        // Slicers
        case .slicers: return ("api/slicing", .get, .request, nil)
        case let .slicerProfiles(slicer):
            return ("api/slicing/\(slicer.urlEncoded)/profiles", .get, .request, nil)
        case let .deleteSlicingProfile(slicerID, profileID):
            return ("api/slicing/\(slicerID.urlEncoded)/profiles/\(profileID)", .delete, .request, nil)
        case .printerProfiles: return ("api/printerprofiles", .get, .request, nil)
        case let .updatePrinterProfile(profileID, data):
            return ("/api/printerprofiles/\(profileID.urlEncoded)", .patch, .request, data)
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
