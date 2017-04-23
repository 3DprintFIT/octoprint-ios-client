//
//  SDCardManagementViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Controller for SD card management
class SDCardManagementViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: SDCardManagementViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SDCardManagementViewModelType) {
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
