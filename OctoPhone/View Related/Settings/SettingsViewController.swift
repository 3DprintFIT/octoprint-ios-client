//
//  SettingsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/12/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

/// Printer settings and configurations
class SettingsViewController: UIViewController {

    /// Settings logic
    private var viewModel: SettingsViewModelType!

    convenience init(viewModel: SettingsViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
