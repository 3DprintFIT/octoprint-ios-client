//
//  SDCard.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// SDCard
final class SDCard {

    // MARK: - Stored properties

    /// Indicates card readynes
    var ready = false

    // MARK: - Computed properties

    // MARK: - Public API

    init(ready: Bool) {
        self.ready = ready
    }
}
