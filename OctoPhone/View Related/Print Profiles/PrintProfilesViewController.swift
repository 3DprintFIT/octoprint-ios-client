//
//  PrintProfilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Print profiles list screen controller
class PrintProfilesViewController: UICollectionViewController {

    /// Controller logic
    private var viewModel: PrintProfilesViewModelType!

    convenience init(viewModel: PrintProfilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
