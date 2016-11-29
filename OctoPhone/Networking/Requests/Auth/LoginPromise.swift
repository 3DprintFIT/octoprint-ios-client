//
//  LoginPromise.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 28/11/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation


final class LoginPromise {

    enum LoginResult {
        case success
        case connectionFailed
        case unauthorized
    }

    let token: String

    let printerUrl: URL

    var finishedWithResult: (LoginResult) -> Void = { _ in }

    init(with token: String, printerUrl: URL) {
        self.token = token
        self.printerUrl = printerUrl
    }
}
