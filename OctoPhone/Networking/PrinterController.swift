//
//  NetworkController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// Network connections for printer
class PrinterController: NSObject {

    /// Network operations queue
    private let queue = OperationQueue()

    /// Data context manager
    private let contextManager: ContextManager

    /// Alamofire session
    private let sessionManager: SessionManager

    /// Operation configuration
    private let operationConfiguration: OperationConfiguration

    /// Remote printer URL
    private let printerURL: URL

    /// Creates new real world printer connection
    ///
    /// - Parameters:
    ///   - printerURL: URL of printer
    ///   - contextManager: Data manager
    init(printerURL: URL, contextManager: ContextManager) {
        let sessionManager = SessionManager()
        var apiURL = printerURL

        if apiURL.lastPathComponent != "api" {
            apiURL.appendPathComponent("api")
        }

        self.contextManager = contextManager
        self.sessionManager = sessionManager
        self.printerURL = apiURL

        operationConfiguration = OperationConfiguration(
            contextManager: contextManager,
            sessionManager: sessionManager,
            baseURL: apiURL
        )
    }

    /// Authenticate to printer
    ///
    /// - Parameter token: Access token
    /// - Returns: Authentication promise
    func autheticate(with token: String) -> AuthenticationPromise {
        let promise = AuthenticationPromise(with: token, printerURL: printerURL)
        let authOperation = AuthenticatateOperation(
            configuration: operationConfiguration,
            authenticationPromise: promise
        )

        queue.addOperation(authOperation)

        return promise
    }
}
