//
//  SlicingProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Slicing profile detail flow delegate
protocol SlicingProfileViewControllerDelegate: class {
    /// Called when slicing profile was successfully deleted
    func deletedSlicingProfile()
}

/// Slicing profile detail controller
class SlicingProfileViewController: BaseViewController {
    // MARK: - Properties

    /// Profile deletion button
    lazy var deleteButton: UIBarButtonItem = {
        // Fixes weird behavior with not calling target action on `self`
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,
                               target: self,
                               action: #selector(deleteProfileButtonTapped))
    }()

    /// Controller logic
    fileprivate var viewModel: SlicingProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SlicingProfileViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        navigationItem.rightBarButtonItem = deleteButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Internal logic

    /// Open decision dialog when user tapped delete button
    func deleteProfileButtonTapped() {
        let controller = UIAlertController(title: nil, message: tr(.doYouReallyWantToDeleteSlicingProfile),
                                           preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: tr(.cancel), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: tr(.delete), style: .destructive) { [weak self] _ in
            self?.viewModel.inputs.deleteProfile()
        }

        controller.addAction(cancelAction)
        controller.addAction(deleteAction)

        present(controller, animated: true, completion: nil)
    }

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }
}
