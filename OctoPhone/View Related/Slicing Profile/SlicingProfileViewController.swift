//
//  SlicingProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Slicing profile detail controller
class SlicingProfileViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: SlicingProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SlicingProfileViewModelType) {
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
