//
//  ControlsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Screen with printer head controls
class ControlsViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: ControlsViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: ControlsViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        view = ControlsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }
}
