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
    case apiVersion(on: URL)

    //MARK: - Files
    case readAllFiles(from: URL)
    case readFiles(from: URL, at: FileLocation)
    case createFile(on: URL, at: FileLocation, parameters: Parameters)
    case readFile(from: URL, name: String, at: FileLocation)
    case issueFileCommand(on: URL, name: String, at: FileLocation, parameters: Parameters)
    case deleteFile(on: URL, name: String, at: FileLocation)

    //MARK: - Connection
    case getAllConnections(from: URL)
    case issueConnectionCommand(to: URL, parameters: Parameters)

    //MARK: - Printer operations
    case readPrinterState(from: URL, parameters: Parameters)
    case issuePrinterHeadCommand(to: URL, parameters: Parameters)
    case issueToolCommand(on: URL, parameters: Parameters)
    case readToolState(from: URL)
    case issueBedCommand(from: URL, paramters: Parameters)
    case readBedState(from: URL)
    case issueSDCommand(on: URL, parameters: Parameters)
    case readSDState(from: URL)
    case issueArbitraryPrinterCommand(to: URL, parameters: Parameters)

    //MARK - Printer profile operations
    case readAllPrinterProfiles(from: URL)
    case createPrinterProfile(on: URL, parameters: Parameters)
    case updatePrinterProfile(on: URL, name: String, parameters: Parameters)
    case deletePrinterProfile(on: URL, name: String)

    //MARK: - Job operations
    case issueJobCommand(on: URL, parameters: Parameters)
    case readJobInformations(from: URL)

    //MARK: - Logs
    case readAllLogs(from: URL)
    case deleteLog(on: URL, path: String)

    //MARK: - Slicing
    case readAllSlicersAndProfiles(from: URL)
    case readSlicerProfiles(from: URL, slicer: String)
    case readSclicerProfile(from: URL, slicer: String, profile: String)
    case createSlicerProfile(on: URL, slicer: String, profile: String)
    case deleteSlicerProfile(on: URL, slicer: String, profile: String)

    //MARK: - Networking data
    var requestData: (baseURL: URL, method: HTTPMethod, path: String, parameters: Parameters?) {
        switch self {
        case .apiVersion(let url): return(url, .get, "version", nil)

        case .readAllFiles(let url): return (url, .get, "files", nil)
        case .readFiles(let url, let location): return (url, .get, "files/\(location.rawValue)", nil)
        case .createFile(let url, let location, let parameters): return (url, .post, "files/\(location.rawValue)", parameters)
        case .readFile(let url, let name, let location): return (url, .get, "files/\(location.rawValue)/\(name)", nil)
        case .issueFileCommand(let url, let name, let location, let parameters): return (url, .post, "files/\(location.rawValue)/\(name)", parameters) // slice, select
        case .deleteFile(let url, let name, let location): return (url, .delete, "files/\(location)/\(name)", nil)

        case .getAllConnections(let url): return (url, .get, "connection", nil)
        case .issueConnectionCommand(let url, let parameters): return (url, .post, "connection", parameters) // connect, disconnect, fake_ack

        case .readPrinterState(let url, let parameters): return (url, .get, "printer", parameters)
        case .issuePrinterHeadCommand(let url, let parameters): return (url, .post, "printer/printhead", parameters) // jog, home, feedrate
        case .issueToolCommand(let url, let parameters): return (url, .post, "printer/tool", parameters) // target, offset, select, extrude, flowrate
        case .readToolState(let url): return (url, .get, "printer/tool", nil)
        case .issueBedCommand(let url, let paramters): return (url, .post, "printer/bed", paramters) // target, offset
        case .readBedState(let url): return (url, .get, "printer/bed", nil)
        case .issueSDCommand(let url, let parameters): return (url, .post, "printer/sd", parameters) // init, refresh, release
        case .readSDState(let url): return (url, .get, "printer/sd", nil)
        case .issueArbitraryPrinterCommand(let url, parameters: let parameters): return (url, .post, "printer/command", parameters)

        case .readAllPrinterProfiles(let url): return (url, .get, "printerprofiles", nil)
        case .createPrinterProfile(let url, let parameters): return (url, .post, "printerprofiles", parameters)
        case .updatePrinterProfile(let url, let name, let parameters): return (url, .patch, "printerprofiles/\(name)", parameters) // TODO: !needs review!
        case .deletePrinterProfile(let url, let name): return (url, .delete, "printerprofiles/\(name)", nil)

        case .issueJobCommand(let url, let parameters): return (url, .post, "job", parameters) // start, cancel, restart, pause[pause, resume, toggle]?
        case .readJobInformations(let url): return (url, .get, "job", nil)

        case .readAllLogs(let url): return (url, .get, "logs", nil)
        case .deleteLog(let url, let path): return (url, .delete, "logs/\(path)", nil)

        case .readAllSlicersAndProfiles(let url): return (url, .get, "slicing", nil)
        case .readSlicerProfiles(let url, let slicer): return (url, .get, "slicing/\(slicer)/profiles", nil)
        case .readSclicerProfile(let url, let slicer, let profile): return (url, .get, "slicing/\(slicer)/profiles/\(profile)", nil)
        case .createSlicerProfile(let url, let slicer, let profile): return (url, .put, "slicing/\(slicer)/profiles/\(profile)", nil)
        case .deleteSlicerProfile(let url, let slicer, let profile): return (url, .delete, "slicing/\(slicer)/profiles/\(profile)", nil)
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
