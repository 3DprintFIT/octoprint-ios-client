//
//  CurrentPrintViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Detail of current print
class CurrentPrintViewController: UICollectionViewController {

    /// Controller logic
    private var viewModel: CurrentPrintViewModelType!

    convenience init(viewModel: CurrentPrintViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

}
