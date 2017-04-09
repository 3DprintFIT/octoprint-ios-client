//
//  FileDetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// File detail controller, allows to manipulate with one specific file.
///
/// File may be selected for print or deleted from printer.
class FileDetailViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: FileDetailViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: FileDetailViewModelType) {
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
        navigationItem.title = viewModel.outputs.screenTitle.value
    }
}
