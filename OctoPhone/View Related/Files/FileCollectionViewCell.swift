//
//  FileCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 05/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Cell representing single file in files list
class FileCollectionViewCell: UICollectionViewCell {
    /// Reuse identifier
    static let identifier = "FileCollectionViewCell"

    /// File cell view model
    var viewModel: FileCellViewModelType? {
        didSet {
            backgroundColor = .red
        }
    }
}
