//
//  PrinterControlViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Manual printer control view controller
class PrinterControlViewController: BaseViewController {
    /// Control logic
    private var viewModel: PrinterControlViewModelType!

    convenience init(viewModel: PrinterControlViewModelType) {
        self.init()

        self.viewModel = viewModel
    }
}
