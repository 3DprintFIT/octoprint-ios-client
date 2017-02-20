//
//  Printer.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 29/11/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Real printer device
final class Printer: Object {

    // MARK: - Stored properties
    /// Stored representation of printer URL
    private dynamic var _url = ""

    /// User's access token for authorization to printer
    dynamic var accessToken = ""

    // MARK: - Computed properties

    /// Printer URL based on stored property
    dynamic var url: URL {
        get {
            return URL(string: _url)!
        }
        set {
            _url = newValue.absoluteString
        }
    }

    // MARK: - Public API

    /// Creates new Printer instance
    ///
    /// - Parameters:
    ///   - url: String representation of printer URL
    ///   - accessToken: User's access token
    convenience init(
        url: URL,
        accessToken: String
        ) {
        self.init()

        self.url = url
        self.accessToken = accessToken
    }

    // MARK: - Realm API
    override static func ignoredProperties() -> [String] {
        return ["url"]
    }
}
