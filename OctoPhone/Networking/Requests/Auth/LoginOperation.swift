//
//  LoginOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


class LoginOperation: NetworkOperation {

    private let token: String

    private let url: URL

    init(configuration: OperationConfiguration, loginPromise: LoginPromise) {
        self.token = loginPromise.token
        self.url = loginPromise.printerUrl

        super.init(configuration: configuration)
    }

    override func start() {
        do {
            var request = try Router.apiVersion(on: URL(string: "")!).asURLRequest()

            request.url = url
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
