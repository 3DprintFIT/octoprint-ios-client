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


    /// Printer URL
    dynamic var url = ""


    /// User's access token for authorization to printer
    dynamic var accessToken = ""


    /// Creates new Printer instance
    ///
    /// - Parameters:
    ///   - url: String representation of printer URL
    ///   - accessToken: User's access token
    convenience init(
        url: String,
        accessToken: String
        ) {
        self.init()

        self.url = url
        self.accessToken = accessToken
    }
}
