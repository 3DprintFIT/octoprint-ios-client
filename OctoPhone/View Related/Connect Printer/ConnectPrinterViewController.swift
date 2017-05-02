//
//  ConnectPrinterViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Icons

/// Connect printer controller flow delegate
protocol ConnectPrinterViewControllerDelegate: class {
    /// Called when user decided to close controller
    func closeButtonTapped()
}

/// Controller which allows to connect octoprint to specific
/// printer interface.
class ConnectPrinterViewController: BaseViewController {
    // MARK: - Properties

    /// Close controller button
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                     target: self, action: #selector(closeButtonTapped))

        return button
    }()

    /// Controller logic
    fileprivate var viewModel: ConnectPrinterViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: ConnectPrinterViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = closeButton
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        title = viewModel.outputs.title.value
    }

    /// UI action button callback
    func closeButtonTapped() {
        viewModel.inputs.closeButtonTapped()
    }
}
