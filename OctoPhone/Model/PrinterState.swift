//
//  PrinterState.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents current state of printer
final class PrinterState: Object {

    // MARK: - Stored properties

    dynamic var state = ""

    // MARK: - Computed properties

    // MARK: - Public API

    convenience init(state: String) {
        self.init()

        self.state = state
    }

    // MARK: - Realm API
}
