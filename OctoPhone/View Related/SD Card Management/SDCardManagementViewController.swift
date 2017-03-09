//
//  SDCardManagementViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controller for SD Card operations and management
class SDCardManagementViewController: UIViewController {

    /// Card management logic
    private var viewModel: SDCardManagementViewModelType!

    convenience init(viewModel: SDCardManagementViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
