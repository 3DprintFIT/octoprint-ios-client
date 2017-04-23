//
//  SlicingProfile.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 29/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable variable_name
/// Installed slicing profile
final class SlicingProfile: Object {

    // MARK: - Stored properties

    /// Slicing profile identifier
    dynamic var ID = ""

    /// Profile name
    dynamic var name: String?

    /// User description of profile
    dynamic var profileDescription: String?

    /// Indicates whether the slicing profile is set as default
    dynamic var isDefault = false

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(ID: String, name: String?, description: String?, isDefault: Bool) {
        self.init()

        self.ID = ID
        self.name = name
        self.profileDescription = description
        self.isDefault = isDefault
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "ID"
    }
}
// swiftlit:enable variable_name
