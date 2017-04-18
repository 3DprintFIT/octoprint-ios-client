//
//  DynamicProvider.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import ReactiveMoya

/// Defines properties required by Target,
/// but does not require base URL as it's
/// added dynamically
protocol TargetPart {
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// The parameters to be incoded in the request.
    var parameters: [String: Any]? { get }

    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool { get }
}

/// Layer between actual requests provider and target type,
/// allows to use dynamic base URL created during run time
struct DynamicTarget: TargetType {
    let baseURL: URL

    let target: TargetPart

    var path: String { return target.path }

    var method: Moya.Method { return target.method }

    var parameters: [String : Any]? { return target.parameters }

    var parameterEncoding: ParameterEncoding { return target.parameterEncoding }

    var sampleData: Data { return target.sampleData }

    var task: Task { return target.task }

    var validate: Bool { return target.validate }

    init(baseURL: URL, target: TargetPart) {
        self.baseURL = baseURL
        self.target = target
    }
}

/// Requests provider allowing to pass base URL during run time
final class DynamicProvider<Target: TargetPart>: ReactiveSwiftMoyaProvider<DynamicTarget> {
    /// Request base URL
    private let baseURL: URL

    init(
        baseURL: URL,
        endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
        stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
        manager: Manager = ReactiveSwiftMoyaProvider<DynamicTarget>.defaultAlamofireManager(),
        plugins: [PluginType] = [], stubScheduler: DateScheduler? = nil,
        trackInflights: Bool = false
    ) {
        self.baseURL = baseURL

        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure:
            stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }

    /// Creates request from TargetPart
    ///
    /// - Parameter target: Target without base URL
    /// - Returns: Response signal
    func request(_ target: Target) -> SignalProducer<Response, MoyaError> {
        let dynamicTarget = DynamicTarget(baseURL: baseURL, target: target)

        return request(dynamicTarget)
    }

    /// Creates actual request from TargetPart, the request can be observed for progress
    ///
    /// - Parameter target: Request Target without base URL
    /// - Returns: Response producer which can be observed for progress
    func requestWithProgress(_ target: Target) -> SignalProducer<ProgressResponse, MoyaError> {
        let dynamicTarget = DynamicTarget(baseURL: baseURL, target: target)

        return requestWithProgress(token: dynamicTarget)
    }
}
