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
enum OctoPrintAPI {
    case version
    case files
}

// MARK: - TargetPart implementation
// Implements Moya protocol for creating Endpoints from Targets
extension OctoPrintAPI: TargetPart {
    var path: String { return requestData.path }

    var method: Moya.Method { return requestData.method }

    var parameters: Parameters? { return requestData.parameters }

    var parameterEncoding: ParameterEncoding { return Moya.JSONEncoding.default }

    var sampleData: Data { return Data() }

    var task: Task { return requestData.task }

    var validate: Bool { return false }

    /// Target to endpoint data maping
    var requestData: (path: String, method: Moya.Method, task: Task, parameters: Parameters?) {
        switch self {
        case .version: return ("api/version", .get, .request, nil)
        case .files: return ("api/files", .get, .request, nil)
        }
    }
}
