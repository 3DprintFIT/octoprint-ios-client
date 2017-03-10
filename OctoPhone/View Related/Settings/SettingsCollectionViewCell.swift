//
//  SettingsCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Cell for settings page
class SettingsCollectionViewCell: UICollectionViewCell {

    /// Reuse identifier of cell
    static let identifier = "SettingsCollectionViewCell"

    /// Cell logic
    var viewModel: SettingsCellViewModelType? {
        didSet {
            backgroundColor = .red
        }
    }
}
