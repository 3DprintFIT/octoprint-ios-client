//
//  TerminalViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// CLI terminal controller
class TerminalViewController: BaseCollectionViewController {

    /// Terminal logic
    private var viewModel: TerminalViewModelType!

    convenience init(viewModel: TerminalViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
