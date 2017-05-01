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

    private weak var controlsView: ControlsView?

    // MARK: - Initializers

    convenience init(viewModel: ControlsViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        let controlsView = ControlsView()

        view = controlsView
        self.controlsView = controlsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        bindViewModel()
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        guard let view = controlsView else {
            return
        }

        view.moveForwardButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadForward()
        }

        view.moveBackButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadBackward()
        }

        view.moveLeftButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadLeft()
        }

        view.moveRightButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadRight()
        }

        view.moveUpButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadUp()
        }

        view.moveDownButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadDown()
        }

        view.moveHomeXYButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadHomeXY()
        }

        view.moveHomeZButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.moveHeadHomeZ()
        }

        reactive.displayableError <~ viewModel.outputs.displayError
    }
}
