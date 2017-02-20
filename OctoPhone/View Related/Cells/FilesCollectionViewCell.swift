//
//  FilesCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 26/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

/// Represents gcode file cell
class FilesCollectionViewCell: UICollectionViewCell {
    /// CollectionView reuse identifier
    static let identifier = "FilesCollectionViewCell"

    /// File name label
    let fileNameLabel = UILabel()

    /// Print count label
    let printCountLabel = UILabel()

    /// Creation date label
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right

        return label
    }()

    /// Estimated print time label
    let estimatedTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3

        return label
    }()

    /// UI sizes
    struct Sizes {
        static let sideViewWidth: CGFloat = 35
        static let spacing: CGFloat = 8
    }

    /// Wrapper for cell main view
    private let mainView = UIView()

    /// Create new cell in given frame
    ///
    /// - Parameter frame: Frame where cell will be displayed
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configure cell subviews
    private func configureView() {
        let subviews = [dateLabel, fileNameLabel, printCountLabel, estimatedTimeLabel, mainView]

        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        estimatedTimeLabel.topAnchor.constraint(equalTo: self.topAnchor)
        estimatedTimeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        estimatedTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                    constant: Sizes.spacing)
        estimatedTimeLabel.widthAnchor.constraint(equalToConstant: Sizes.sideViewWidth)

        mainView.topAnchor.constraint(equalTo: self.topAnchor)
        mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        mainView.leadingAnchor.constraint(equalTo: estimatedTimeLabel.trailingAnchor,
                                          constant: Sizes.spacing)
    }
}
