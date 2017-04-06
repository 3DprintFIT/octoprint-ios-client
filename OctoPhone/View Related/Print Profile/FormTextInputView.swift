//
//  FormTextInputView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Form text input with description and optional suffix label
class FormTextInputView: UIView {

    struct Layout {
        static let sideMargin: CGFloat = 15
        static let padding: CGFloat = 7
        static let minTextFieldSize = 28
    }

    weak var descriptionLabel: UILabel!

    weak var textField: UITextField!

    weak var suffixLabel: UILabel!

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100,
                      height: Layout.padding + descriptionLabel.frame.height + Layout.padding
                        + textField.frame.height + Layout.padding)
    }

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        let descriptionLabel = UILabel()
        let textField = UITextField()
        let suffixLabel = UILabel()

        addSubview(descriptionLabel)
        addSubview(textField)
        addSubview(suffixLabel)

        self.descriptionLabel = descriptionLabel
        self.textField = textField
        self.suffixLabel = suffixLabel

        createLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal logic

    private func createLayout() {
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        suffixLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(
                UIEdgeInsets(top: Layout.padding, left: Layout.sideMargin, bottom: 0,
                             right: Layout.sideMargin))
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Layout.padding)
            make.leading.equalTo(descriptionLabel)
            make.trailing.equalTo(suffixLabel.snp.leading).offset(-Layout.padding)
            make.height.greaterThanOrEqualTo(Layout.minTextFieldSize)
            make.bottom.equalToSuperview().inset(Layout.padding)
        }

        suffixLabel.snp.makeConstraints { make in
            make.lastBaseline.equalTo(textField)
            make.trailing.equalToSuperview().inset(Layout.sideMargin)
        }
    }
}
