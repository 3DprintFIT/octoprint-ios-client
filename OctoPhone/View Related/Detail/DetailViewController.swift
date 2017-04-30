//
//  DetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Icons

/// Printer detail flow interface
protocol DetailViewControllerDelegate: class {
    /// Called when usertappd on controls button
    func controlsButtonTapped()
}

/// Shows basic informations about printer
class DetailViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: DetailViewModelType!

    /// Navigation button for controls screen flow
    private lazy var controlsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(withIcon: FontAwesomeIcon._449Icon, size: CGSize(width: 24, height: 24),
                                     target: self, action: #selector(controlsButtonTapped))

        return button
    }()

    // MARK: - Initializers

    convenience init(viewModel: DetailViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = controlsButton

        bindViewModel()
    }

    // MARK: - Internal logic

    /// UI callback for controls button tap
    func controlsButtonTapped() {
        viewModel.inputs.controlsButtonTapped()
    }

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }
}
