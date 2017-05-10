//
//  PrinterListCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Real word printer overview
class PrinterListCollectionViewCell: UICollectionViewCell, TypedCell {

    /// CollectionView reuse identifier
    static let identifier = "PrinterOverviewCollectionViewCell"

    /// Printer photo
    let photo = UIImageView()

    /// Printing status label
    let statusLabel = UILabel()

    /// Printing progress view
    let printProgress = UIProgressView()

    /// Cell view model
    let viewModel = MutableProperty<PrinterListCellViewModelType?>(nil)

    /// Holds all view size constants
    struct Sizes {
        /// Height of the printer photo view
        static let photoHeight: CGFloat = 120

        /// Default left margin
        static let leftMargin: CGFloat = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let textBackgroundView = UIView()

        contentView.addSubview(photo)
        contentView.addSubview(textBackgroundView)
        contentView.addSubview(statusLabel)

        photo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.top.equalToSuperview()
        }

        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(photo).offset(-7)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        textBackgroundView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(statusLabel).offset(-7)
        }

        contentView.backgroundColor = .white
        textBackgroundView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        photo.contentMode = .scaleAspectFit
    }

    /// Binds ViewModel to UI
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        photo.reactive.image <~ vm.flatMap(.latest) { $0.outputs.printerStream }
        statusLabel.reactive.text <~ vm.flatMap(.latest) { $0.outputs.printerName }
    }
}
