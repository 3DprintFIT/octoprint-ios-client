//
//  ClosePrinterCellCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell for printer detail close action
class ClosePrinterCellCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "ClosePrinterCellCollectionViewCell"

    // MARK: Public API

    /// Cell logic
    let viewModel = MutableProperty<ClosePrinterCellViewModelType?>(nil)

    // MARK: Private properties

    /// Actualo close button
    let closeButton: UIButton = {
        let button = UIButton(type: .system)

        button.tintColor = Colors.Pallete.dangerRed

        return button
    }()

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

        contentView.addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Internal logic

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        closeButton.reactive.title(for: .normal) <~ vm.flatMap(.latest) { $0.outputs.text }
        vm.combineLatest(with: closeButton.reactive.controlEvents(.touchUpInside))
            .startWithValues { viewModel, _ in
                viewModel.inputs.closePrinterButtonTapped()
            }
    }
}
