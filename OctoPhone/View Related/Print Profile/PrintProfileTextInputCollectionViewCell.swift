//
//  PrintProfileTextInputCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

/// Cell for text input
class PrintProfileTextInputCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "PrintProfileTextInputCollectionViewCell"

    // MARK: Public API

    /// Cell logic
    let viewModel = MutableProperty<PrintProfileTextInputCellViewModelType?>(nil)

    // MARK: Private properties

    /// Description for text input
    private let descriptionLabel = UILabel()

    /// Actual text input value
    private let textField = UITextField()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15,
                                                                       bottom: 0, right: 0))
            make.trailing.equalTo(textField.snp.leading).offset(-15)
        }

        textField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0,
                                                                           bottom: 0, right: 15))
            make.width.equalTo(70)
        }
    }

    // MARK: Internal logic

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        descriptionLabel.reactive.text <~ vm.flatMap(.latest) { $0.outputs.descriptionText.producer }
        textField.reactive.continuousTextValues.signal.observeValues { [weak self] text in
            self?.viewModel.value?.inputs.textValueChanged(text)
        }
    }
}
