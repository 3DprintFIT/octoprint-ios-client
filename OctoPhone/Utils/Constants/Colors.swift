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
        static let detailText = Pallete.greyHue3

        /// Color for section headers etc, mostly for elements
        /// which stays in "empty" space or on darker background.
        static let sectionHeading = Pallete.greyHue1
    }

    /// Colors for common views
    struct Views {
        /// Common background color for View Controllers
        static let defaultControllerBackground = Pallete.greyHue2

        /// Common view separator view background
        static let cellSeparator = Pallete.greyHue4
    }

    struct Pallete {
        /// Grey color - hue 1/4
        static let greyHue1 = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        /// Grey color - hue 2/4
        static let greyHue2 = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9647058824, alpha: 1)

        /// Grey color - hue 3/4
        static let greyHue3 = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4823529412, alpha: 1)

        /// Grey color - hue 4/4
        static let greyHue4 = #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.4, alpha: 1)

        /// Standard red color for danger actions
        static let dangerRed = #colorLiteral(red: 0.9294117647, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
    }
}
