//
//  ListHeadingView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit

/// List item with key value labels
class ListHeadingView: UIView {

    // MARK: Public API

    /// Item description
    let headingLabel = UILabel()

    /// Item bottom separator view
    let separatorView = UIView()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }

    // MARK: Private properties

    // MARK: Initializers

    convenience init() {
        self.init(frame: .zero)

        headingLabel.font = .preferredFont(forTextStyle: .caption1)
        headingLabel.textColor = Colors.Texts.sectionHeading
        separatorView.backgroundColor = Colors.Views.cellSeparator

        addSubview(headingLabel)
        addSubview(separatorView)
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        headingLabel.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15,
                                                                               bottom: 8, right: 15))
        }

        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.leading.trailing.equalToSuperview().inset(0)
        }
    }
}
