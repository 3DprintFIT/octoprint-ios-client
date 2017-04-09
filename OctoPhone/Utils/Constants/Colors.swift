//
//  Colors.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Common UI elements colors
struct Colors {

    /// Colors for texts, labels etc.
    struct Texts {
        /// Base light gray for elements which are on white
        static let detailText = UIColor(red: 117/255, green: 117/255, blue: 123/255, alpha: 1.0)

        /// Color for section headers etc, mostly for elements
        /// which stays in "empty" space or on darker background.
        static let sectionHeading = UIColor(red: 97/255, green: 97/255, blue: 102/255, alpha: 1.0)
    }

    /// Colors for common views
    struct Views {
        /// Common background color for View Controllers
        static let defaultControllerBackground = UIColor(red: 239/255, green: 239/255,
                                                         blue: 246/255, alpha: 1.0)

        /// Common view separator view background
        static let cellSeparator = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1.0)
    }
}
