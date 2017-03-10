//
//  SlicingViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Slicing profiles screen controller
class SlicingViewController: UICollectionViewController {

    /// Slicing controller logic
    private var viewModel: SlicingViewModelType!

    convenience init(viewModel: SlicingViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
