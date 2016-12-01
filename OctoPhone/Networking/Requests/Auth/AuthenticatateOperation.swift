//
//  LoginOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticatateOperation: NetworkOperation {

    private let token: String

    private let authenticationPromise: AuthenticationPromise

    init(configuration: OperationConfiguration, authenticationPromise: AuthenticationPromise) {
        self.token = authenticationPromise.token
        self.authenticationPromise = authenticationPromise

        super.init(configuration: configuration)
    }

    override func start() {
        do {
            var request = try Router.apiVersion(on: authenticationPromise.printerURL).asURLRequest()

            request.addValue(token, forHTTPHeaderField: "X-Api-Key")

            sessionManager.request(request).validate().responseJSON(completionHandler: handle)
        } catch {
            isFinished = true
            self.error = error
        }
    }

    public func handle(response: DataResponse<Any>) {
        switch response.result {
        case .failure(let error):
            self.error = error
        case .success(_):
            break
        }

        print("Login finished with status: \(error == nil)\(error == nil ? "" : " \(error)")")

        isFinished = true
    }
}
