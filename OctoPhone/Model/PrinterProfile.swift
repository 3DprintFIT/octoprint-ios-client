//
//  PrinterProfile.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable variable_name
/// Printing Profile
final class PrinterProfile: Object {

    // MARK: - Stored properties

    /// Unique profile identifier
    dynamic var ID = ""

    /// Printer model
    dynamic var model = ""

    /// Profile display name
    dynamic var name = ""

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(ID: String, model: String, name: String) {
        self.init()

        self.ID = ID
        self.model = model
        self.name = name
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "ID"
    }
}
// swiftlint:enable variable_name
