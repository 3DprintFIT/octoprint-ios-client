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

        self.contextManager = contextManager
        self.sessionManager = sessionManager
        self.printerURL = printerURL

        operationConfiguration = OperationConfiguration(
            contextManager: contextManager,
            sessionManager: sessionManager,
            baseURL: printerURL
        )
    }

    /// Validate user credentials
    ///
    /// - Parameters:
    ///   - token: User secret token
    ///   - name: User-friendly name
    /// - Returns: Request result
    func autheticate(withToken token: String, printerName name: String) {

    }
}
