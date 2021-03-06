//
//  PrintProfileCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Print profile list cell
class PrintProfileCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "PrintProfileCollectionViewCell"

    // MARK: Public API

    /// Cell logic
    let viewModel = MutableProperty<PrintProfileCellViewModelType?>(nil)

    // MARK: Private properties

    private let nameLabel = UILabel()

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

        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
    }

    // MARK: Internal logic

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        nameLabel.reactive.text <~ vm.flatMap(.latest) { $0.outputs.name }
    }
}
