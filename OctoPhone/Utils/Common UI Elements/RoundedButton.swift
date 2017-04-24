//
//  RoundedButton.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit

/// Shortcut for rounded button,
/// the radius is computed from width, height is automatically adjusted
/// to be equal to the current width
class RoundedButton: UIButton {

    /// Width of border around button
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    /// Border color
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }

            return nil
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    /// Context for KVO observing
    private var sizeContext = 0

    init(borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        super.init(frame: .zero)

        self.borderWidth = borderWidth
        self.borderColor = borderColor

        snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
}
