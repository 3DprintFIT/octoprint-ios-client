//
//  TokenPlugin.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Moya

/// OctoPrint Auth token plugin
final class TokenPlugin {
    /// HTTP header key for injected token
    fileprivate static let tokenKey = "X-Api-Key"

    /// User's secret access token
    fileprivate let token: String

    init(token: String) {
        self.token = token
    }
}

// MARK: - PluginType
// Implementation of Moya plugin API
extension TokenPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request

        request.addValue(token, forHTTPHeaderField: TokenPlugin.tokenKey)

        return request
    }
}
