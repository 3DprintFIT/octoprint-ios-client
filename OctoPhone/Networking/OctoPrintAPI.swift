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
/// - uploadFile: Uploads file to specific location, with given name from given URL
/// - deleteFile: Deletes file with given file name from specific location
/// - printFile: Selects file at given location with gitven name for print
/// - logs: Downloads list of list
/// - downloadLog: Downloads log file to internal sotrage
/// - deleteLog: Deletes specified log
/// - slicers: Downloads list of installed slicers
/// - slicerProfiles: Downloads list of slicing profiles fro given slicer
/// - createSlicerProfile: Creates or updates slicer profiles with given name and description
/// - deleteSlicingProfile: Deletes given slicing profile from printer
/// - printProfiles - Downloads list of installed print profiles
/// - createPrinterProfile - Creates new printer profile on printer
/// - updatePrinterProfile - Updates existing printer profile
/// - deletePrintProfile - Deletes given profile from printer
/// - sdCardState - Checks if connected SD card is ready
/// - sdCardCommand - Issues SD card command
/// - jogPrintHead - Jogs print head in given direction on given axis
/// - homePrintHead - Moves print head to home position on given axes
/// - extrudeFilamen - Extrudes fixed amount of filament
enum OctoPrintAPI {
    // Command
    case version
    // Printer
    case sendCommand(String)
    // Files
    case files
    case filesAtLocation(FileOrigin)
    case uploadFile(FileOrigin, String, URL)
    case deleteFile(FileOrigin, String)
    case printFile(FileOrigin, String)
    // Logs
    case logs
    case downloadLog(String)
    case deleteLog(String)
    // Slicers
    case slicers
    case slicerProfiles(String)
    case createSlicerProfile(slicerID: String, name: String, description: String)
    case deleteSlicingProfile(slicerID: String, profileID: String)
    // Printer profiles
    case printerProfiles
    case createPrinterProfile(data: Parameters)
    case updatePrinterProfile(profileID: String, data: Parameters)
    case deletePrintProfile(profileID: String)
    // SD Card Management
    case sdCardState
    case sdCardCommand(SDCardCommand)
    // Print head controls
    case jogPrintHead(JogAxis, JogDirection)
    case homePrintHead(Set<JogAxis>)
    // Print tool controls
    case extrudeFilament
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

        case let .sendCommand(command): return ("api/printer/command", .post, .request, ["command": command])

        // Files

        case .files: return ("api/files", .get, .request, nil)

        case let .filesAtLocation(location): return ("api/files/\(location.rawValue.urlEncoded)", .get, .request, nil)

        case let .uploadFile(destination, fileName, fileURL):
            return ("api/files/\(destination.rawValue.urlEncoded)", .post, .upload(
                UploadType.multipart([MultipartFormData(provider: .file(fileURL), name: "file",
                                                        fileName: fileName, mimeType: nil)])), nil)

        case let .deleteFile(target, filename):
            return ("api/files/\(target.rawValue.urlEncoded)/\(filename.urlEncoded)", .delete, .request, nil)

        case let .printFile(location, filename):
            return ("api/files/\(location.rawValue.urlEncoded)/\(filename.urlEncoded)", .post,
                    .request, ["command": "select", "print": true])

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

        case let .createSlicerProfile(slicerID, name, description):
            return ("api/slicing/\(slicerID.urlEncoded)/profiles/\(name.urlEncoded)", .put, .request,
                    ["displayName": name, "description": description])

        case let .deleteSlicingProfile(slicerID, profileID):
            return ("api/slicing/\(slicerID.urlEncoded)/profiles/\(profileID)", .delete, .request, nil)

        // Printer profiles

        case .printerProfiles: return ("api/printerprofiles", .get, .request, nil)

        case let .createPrinterProfile(data):
            return ("api/printerprofiles", .post, .request, data)

        case let .updatePrinterProfile(profileID, data):
            return ("api/printerprofiles/\(profileID.urlEncoded)", .patch, .request, data)

        case let .deletePrintProfile(profileID):
            return ("api/printerprofiles/\(profileID.urlEncoded)", .delete, .request, nil)

        // SD Card management

        case .sdCardState:
            return ("api/printer/sd", .get, .request, nil)

        case let .sdCardCommand(command):
            return ("api/printer/sd", .post, .request, ["command": command.rawValue])

        // Print head controls

        case let .jogPrintHead(axis, direction):
            return ("api/printer/printhead", .post, .request, ["command": "jog", axis.rawValue: direction.rawValue ])

        case let .homePrintHead(axes):
            return ("api/printer/printhead", .post, .request, ["command": "home", "axes": axes.map { $0.rawValue }])

        // Print tool controls
        case .extrudeFilament:
            return ("api/printer/tool", .post, .request, ["command": "extrude", "amount": 5])
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

// swiftlint:disable identifier_name
/// Axis for print head jog command
///
/// - x: X axis
/// - y: Y axis
/// - z: Z axis
enum JogAxis: String, Hashable {
    case x
    case y
    case z

    var hashValue: Int {
        return self.rawValue.hashValue
    }

    static func == (lhs: JogAxis, rhs: JogAxis) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
// swiftlint:enable identifier_name

/// Direction of print head move
///
/// - increase: Moves print head in positive direction
/// - decrease: Moves print head in neagtive direction
enum JogDirection: Int {
    case increase = 10
    case decrease = -10
}
