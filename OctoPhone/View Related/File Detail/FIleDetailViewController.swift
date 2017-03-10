//
//  FIleDetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Printer stored file detail controller
class FIleDetailViewController: BaseCollectionViewController {

    /// Controller logic
    private var viewModel: FileDetailViewModelType!

    convenience init(viewModel: FileDetailViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
