//
//  ListItemView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// List item with key value labels
class ListItemView: UIView {

    // MARK: Public API

    /// Item description
    let descriptionLabel = UILabel()

    /// Item detail text
    let detailLabel = UILabel()

    /// Item bottom separator view
    let separatorView = UIView()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }

    // MARK: Private properties

    // MARK: Initializers

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = .white

        descriptionLabel.text = "Test"

        detailLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        detailLabel.textColor = Colors.Texts.detailText
        detailLabel.textAlignment = .right
        separatorView.backgroundColor = Colors.Views.cellSeparator

        addSubview(descriptionLabel)
        addSubview(detailLabel)
        addSubview(separatorView)
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15,
                                                                          bottom: 0, right: 0))
            make.trailing.equalTo(detailLabel.snp.leading).offset(-15)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0,
                                                                           bottom: 0, right: 15))
        }

        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15,
                                                                               bottom: 0, right: 0))
        }
    }
}
