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

    /// Stored representation of stream URL
    private dynamic var _streamUrl: String?

    /// User's access token for authorization to printer
    dynamic var accessToken = ""

    /// User-frindly printer name
    dynamic var name = ""

    // MARK: - Computed properties

    /// Getter for printer ID backed by it's URL
    // swiftlint:disable identifier_name
    var ID: String { return _url }
    // swiftlint:enable identifier_name

    /// Printer URL based on stored property
    var url: URL {
        get {
            return URL(string: _url)!
        }
        set {
            _url = newValue.absoluteString
        }
    }

    /// Print stream URL
    var streamUrl: URL? {
        get {
            guard let url = _streamUrl else { return nil }

            return URL(string: url)
        }
        set {
            _streamUrl = newValue?.absoluteString
        }
    }

    // MARK: - Public API

    /// Creates new Printer instance
    ///
    /// - Parameters:
    ///   - url: String representation of printer URL
    ///   - accessToken: User's access token
    convenience init(url: URL, accessToken: String, name: String, streamUrl: URL?) {
        self.init()

        self.url = url
        self.accessToken = accessToken
        self.name = name
        self.streamUrl = streamUrl
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "_url"
    }

    override static func ignoredProperties() -> [String] {
        return ["url", "streamUrl"]
    }
}
