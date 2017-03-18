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

/// Command cell in terminal
class CommandCollectionViewCell: UICollectionViewCell {

    static let identifier = "CommandCollectionViewCell"

    /// Displays command value
    private let commandLabel = UILabel()

    /// Cell logic
    var viewModel: CommandCellViewModelType? {
        didSet {
            guard let viewModel = viewModel else { return }

            commandLabel.reactive.text <~ viewModel.outputs.commandValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(commandLabel)

        commandLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        commandLabel.backgroundColor = .green

        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
