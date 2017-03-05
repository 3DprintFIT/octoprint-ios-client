//
//  PrinterListCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

/// Real word printer overview
class PrinterListCollectionViewCell: UICollectionViewCell {

    /// CollectionView reuse identifier
    static let identifier = "PrinterOverviewCollectionViewCell"

    /// Printer photo
    let photo = UIImageView()

    /// Printing status label
    let statusLabel = UILabel()

    /// Printing progress view
    let printProgress = UIProgressView()

    /// Cell view model
    var viewModel: PrinterListCellViewModelType? {
        didSet {
            // guard let viewModel = viewModel else { return }

            // nameLabel.text = viewmModel.printerName
            // urlLabel.text = viewModel.printerURL
            backgroundColor = .red
        }
    }

    /// Holds all view size constants
    struct Sizes {
        /// Height of the printer photo view
        static let photoHeight: CGFloat = 120

        /// Default left margin
        static let leftMargin: CGFloat = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configure cell subviews
    private func configureView() {
        let subviews = [photo, statusLabel, printProgress]

        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        let constraints = [
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.widthAnchor.constraint(equalTo: widthAnchor),
            photo.heightAnchor.constraint(equalToConstant: Sizes.photoHeight),
            statusLabel.topAnchor.constraint(equalTo: photo.bottomAnchor),
            statusLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Sizes.leftMargin
            )
        ]

        constraints.forEach { $0.isActive = true }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil

        // nameLabel.text = viewmModel.printerName
        // urlLabel.text = viewModel.printerURL
    }
}
