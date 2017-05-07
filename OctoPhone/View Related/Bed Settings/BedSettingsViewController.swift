//
//  BedSettingsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Bed settings flow delegate
protocol BedSettingsViewControllerDelegate: class {
    /// Called when user wants to leave screem
    func doneButtonTapped()
}

/// Controller for printer bed temperatures settings
class BedSettingsViewController: BaseViewController {
    // MARK: - Properties

    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                     action: #selector(doneButtonTapped))

        return button
    }()

    /// Controller logic
    fileprivate var viewModel: BedSettingsViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: BedSettingsViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = doneButton
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }

    /// UI Callback for done button tap
    func doneButtonTapped() {
        viewModel.inputs.doneButtonTapped()
    }
}
