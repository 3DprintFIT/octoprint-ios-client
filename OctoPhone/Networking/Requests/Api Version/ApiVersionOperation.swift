//
//  ApiVersionOperation.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


class ApiVersionOperation: NetworkOperation {

    override func start() {
        sessionManager.request(Router.apiVersion).validate().responseJSON(completionHandler: receive)
    }

    public func receive(response: DataResponse<Any>) {
        if isCancelled {
            isFinished = true
            return
        }

        switch response.result {
        case .success(let data):
            print(data)
        case .failure(let error):
            self.error = error
        }

        isFinished = true
    }
}
