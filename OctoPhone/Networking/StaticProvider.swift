//
//  StaticProvider.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveMoya
import Moya

/// Static API content server
typealias StaticContentProvider = ReactiveSwiftMoyaProvider<StaticAPI>

/// Creates static request on base URL without any kind of routing
///
/// - get: Static request to given URL
enum StaticAPI: TargetType {
    case get(URL)

    var baseURL: URL {
        switch self {
        case let .get(url): return url
        }
    }

    var path: String { return "" }

    var method: Moya.Method { return .get }

    var parameters: [String: Any]? { return nil }

    var parameterEncoding: ParameterEncoding { return Moya.URLEncoding.default }

    var sampleData: Data { fatalError("Static request cannot be stubbed") }

    var task: Task { return .request }

    var validate: Bool { return false }
}
