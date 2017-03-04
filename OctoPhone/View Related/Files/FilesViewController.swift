//
//  FilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/12/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

/// Lists stored files on printer
class FilesViewController: UIViewController {

    /// Controller view model
    private var viewModel: FilesViewModelType!

    convenience init(viewModel: FilesViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputs.viewDidLoad()
    }
}
