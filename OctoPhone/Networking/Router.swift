//
//  OctoApi.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


enum Router: URLRequestConvertible {
    enum FileLocation: String {
        case sd
        case local
    }

    enum FileCommand: String {
        case select
        case slice
    }

    //MARK: - API Informations
    case apiVersion

    //MARK: - Files
    case readAllFiles
    case readFiles(at: FileLocation)
    case createFile(at: FileLocation, parameters: Parameters)
    case readFile(name: String, at: FileLocation)
    case issueFileCommand(name: String, at: FileLocation, parameters: Parameters)
    case deleteFile(name: String, at: FileLocation)

    //MARK: - Connection
    case getAllConnections
    case issueConnectionCommand(parameters: Parameters)

    //MARK: - Printer operations
    case readPrinterState(parameters: Parameters)
    case issuePrinterHeadCommand(parameters: Parameters)
    case issueToolCommand(parameters: Parameters)
    case readToolState
    case issueBedCommand(paramters: Parameters)
    case readBedState
    case issueSDCommand(parameters: Parameters)
    case readSDState
    case issueArbitraryPrinterCommand(parameters: Parameters)

    //MARK - Printer profile operations
    case readAllPrinterProfiles
    case createPrinterProfile(parameters: Parameters)
    case updatePrinterProfile(name: String, parameters: Parameters)
    case deletePrinterProfile(name: String)

    //MARK: - Job operations
    case issueJobCommand(parameters: Parameters)
    case readJobInformations

    //MARK: - Logs
    case readAllLogs
    case deleteLog(path: String)

    //MARK: - Slicing
    case readAllSlicersAndProfiles
    case readSlicerProfiles(slicer: String)
    case readSclicerProfile(slicer: String, profile: String)
    case createSlicerProfile(slicer: String, profile: String)
    case deleteSlicerProfile(slicer: String, profile: String)

    //MARK: - Networking data
    var requestData: (method: HTTPMethod, path: String, parameters: Parameters?) {
        switch self {
        case .apiVersion: return(.get, "version", nil)

        case .readAllFiles(): return (.get, "files", nil)
        case .readFiles(let location): return (.get, "files/\(location.rawValue)", nil)
        case .createFile(let location, let parameters): return (.post, "files/\(location.rawValue)", parameters)
        case .readFile(let name, let location): return (.get, "files/\(location.rawValue)/\(name)", nil)
        case .issueFileCommand(let name, let location, let parameters): return (.post, "files/\(location.rawValue)/\(name)", parameters) // slice, select
        case .deleteFile(let name, let location): return (.delete, "files/\(location)/\(name)", nil)

        case .getAllConnections: return (.get, "connection", nil)
        case .issueConnectionCommand(let parameters): return (.post, "connection", parameters) // connect, disconnect, fake_ack

        case .readPrinterState(let parameters): return (.get, "printer", parameters)
        case .issuePrinterHeadCommand(let parameters): return (.post, "printer/printhead", parameters) // jog, home, feedrate
        case .issueToolCommand(let parameters): return (.post, "printer/tool", parameters) // target, offset, select, extrude, flowrate
        case .readToolState: return (.get, "printer/tool", nil)
        case .issueBedCommand(let paramters): return (.post, "printer/bed", paramters) // target, offset
        case .readBedState: return (.get, "printer/bed", nil)
        case .issueSDCommand(let parameters): return (.post, "printer/sd", parameters) // init, refresh, release
        case .readSDState: return (.get, "printer/sd", nil)
        case .issueArbitraryPrinterCommand(parameters: let parameters): return (.post, "printer/command", parameters)

        case .readAllPrinterProfiles: return (.get, "printerprofiles", nil)
        case .createPrinterProfile(let parameters): return (.post, "printerprofiles", parameters)
        case .updatePrinterProfile(let name, let parameters): return (.patch, "printerprofiles/\(name)", parameters) // TODO: !needs review!
        case .deletePrinterProfile(let name): return (.delete, "printerprofiles/\(name)", nil)

        case .issueJobCommand(let parameters): return (.post, "job", parameters) // start, cancel, restart, pause[pause, resume, toggle]?
        case .readJobInformations: return (.get, "job", nil)

        case .readAllLogs: return (.get, "logs", nil)
        case .deleteLog(let path): return (.delete, "logs/\(path)", nil)

        case .readAllSlicersAndProfiles: return (.get, "slicing", nil)
        case .readSlicerProfiles(let slicer): return (.get, "slicing/\(slicer)/profiles", nil)
        case .readSclicerProfile(let slicer, let profile): return (.get, "slicing/\(slicer)/profiles/\(profile)", nil)
        case .createSlicerProfile(let slicer, let profile): return (.put, "slicing/\(slicer)/profiles/\(profile)", nil)
        case .deleteSlicerProfile(let slicer, let profile): return (.delete, "slicing/\(slicer)/profiles/\(profile)", nil)
        }
    }

    static let baseURLString = "https://example.com"

    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let requestData = self.requestData

        var urlRequest = URLRequest(url: url.appendingPathComponent(requestData.path))
        urlRequest.httpMethod = requestData.method.rawValue

        urlRequest = try URLEncoding.default.encode(urlRequest, with: requestData.parameters)
        
        return urlRequest
    }
}
