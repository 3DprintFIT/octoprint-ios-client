//
//  LogDetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Log detail screen controller
class LogDetailViewController: BaseViewController {

    /// Log detail logic
    private var viewModel: LogDetailViewModelType!

    convenience init(viewModel: LogDetailViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
