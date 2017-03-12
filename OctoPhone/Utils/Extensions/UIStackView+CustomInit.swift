//
//  UIStackView+CustomInit.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 12/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

extension UIStackView {
    /// Convenience stack initializer with common used properties
    ///
    /// - Parameters:
    ///   - arrangedSubviews: Subviews which will be arranged by stackview
    ///   - axis: Expansion axis
    ///   - spacing: Spacing between arranged views
    ///   - distribution: How the subviews are distributed
    ///   - alignment: Subviews alignment
    convenience init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis,
                     spacing: CGFloat = 0.0, distribution: UIStackViewDistribution = .fill,
                     alignment: UIStackViewAlignment = .fill) {
        self.init(arrangedSubviews: arrangedSubviews)

        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}
