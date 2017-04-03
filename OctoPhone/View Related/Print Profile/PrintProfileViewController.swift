//
//  PrintProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Print profile detail controller
class PrintProfileViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: PrintProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: PrintProfileViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }
}
