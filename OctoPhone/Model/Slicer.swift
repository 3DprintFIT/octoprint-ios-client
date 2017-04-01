//
//  Slicer.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 29/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable variable_name
/// Printer slicer
final class Slicer: Object {

    // MARK: - Stored properties

    /// Slicer identifier
    dynamic var ID = ""

    /// Display name of slicer
    dynamic var name: String?

    /// Indicates whether the slicer is set as default
    dynamic var isDefault = false

    /// Available slicing profiles
    let slicingProfiles = List<SlicingProfile>()

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(ID: String, name: String?, isDefault: Bool) {
        self.init()

        self.ID = ID
        self.name = name
        self.isDefault = isDefault
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "ID"
    }
}
// swiftlint:enable variable_name
