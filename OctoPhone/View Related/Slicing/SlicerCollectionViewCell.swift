//
//  SlicingCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell for slicer list
class SlicerCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "SlicerCollectionViewCell"

    /// Cell logic
    let viewModel = MutableProperty<SlicerCellViewModelType?>(nil)

    /// Slicer name label
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
    }

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        nameLabel.reactive.text <~ vm.map({ $0.outputs.slicerName.value })
    }
}
