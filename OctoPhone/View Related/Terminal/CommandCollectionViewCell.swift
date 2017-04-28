//
//  CommandCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import Result

/// Command cell in terminal
class CommandCollectionViewCell: UICollectionViewCell {

    static let identifier = "CommandCollectionViewCell"

    /// Displays command value
    private let commandLabel = UILabel()

    /// Cell logic
    var viewModel = MutableProperty<CommandCellViewModelType?>(nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(commandLabel)

        commandLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }

        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Binds logic to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        commandLabel.reactive.text <~ vm.flatMap(.latest) { $0.outputs.commandValue }
        contentView.reactive.backgroundColor <~ vm
            .flatMap(.latest) { $0.outputs.failed }
            .map { $0 ? Colors.Pallete.dangerRed : .clear }
    }
}
