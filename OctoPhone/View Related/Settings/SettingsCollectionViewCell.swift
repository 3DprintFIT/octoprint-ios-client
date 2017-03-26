//
//  SettingsCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell for settings page
class SettingsCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "SettingsCollectionViewCell"

    /// Settings name text label
    private let settingsTextLabel = UILabel()

    /// Cell logic
    let viewModel = MutableProperty<SettingsCellViewModelType?>(nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(settingsTextLabel)
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        settingsTextLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        }
    }

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        settingsTextLabel.reactive.text <~ vm.flatMap(.latest) { $0.outputs.name }
    }
}
