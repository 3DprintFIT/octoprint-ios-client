//
//  LoginPromise.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 28/11/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation


final class AuthenticationPromise {

    enum AuthenticationResult {
        case success
        case connectionFailed
        case unauthorized
    }

    let token: String

    let printerURL: URL

    var finishedWithResult: (AuthenticationResult) -> Void = { _ in }

    init(with token: String, printerURL: URL) {
        self.token = token
        self.printerURL = printerURL
    }
}
