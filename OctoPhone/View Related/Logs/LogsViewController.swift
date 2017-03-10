//
//  LogsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Logs list controller
class LogsViewController: BaseCollectionViewController {

    /// Logs controller logic
    private var viewModel: LogsViewModelType!

    convenience init(viewModel: LogsViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
