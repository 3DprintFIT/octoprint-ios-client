//
//  SlicingProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Slicing profile detail flow delegate
protocol SlicingProfileViewControllerDelegate: class {
    /// Called when slicing profile was successfully deleted
    func deletedSlicingProfile()

    /// Called when user tapped on done button
    func doneButtonTapped()
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

    /// Done button
    lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self,
                               action: #selector(doneButtonTapped))
    }()

    /// Button for creating cancellation
    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                               action: #selector(cancelButtonTapped))
    }()

    /// Profile detail items view
    private let profileView = SlicingProfileView()

    /// Controller logic
    fileprivate var viewModel: SlicingProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SlicingProfileViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        view.addSubview(profileView)
        edgesForExtendedLayout = []

        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem = doneButton

        bindViewModel()
    }

    // MARK: - Internal logic

    /// UI callback for done button
    func doneButtonTapped() {
        view.endEditing(true)
        viewModel.inputs.doneButtonTapped()
    }

    /// UI callback for cancel button
    func cancelButtonTapped() {
        view.endEditing(true)
        viewModel.inputs.cancelButtonTapped()
    }

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
        let outputs = viewModel.outputs

        viewModel.outputs.title.producer.startWithValues { [weak self] title in self?.title = title }

        if !viewModel.outputs.deleteButtonIsVisible.value {
            navigationItem.leftBarButtonItem = cancelButton
        }

        profileView.nameLabel.reactive.text <~ outputs.nameText
        profileView.descriptionLabel.reactive.text <~ outputs.descriptionText

        profileView.nameTextField.reactive.isEnabled <~ outputs.contentIsEditable
        profileView.descriptionTextField.reactive.isEnabled <~ outputs.contentIsEditable
        profileView.nameTextField.reactive.text <~ outputs.profileName
        profileView.descriptionTextField.reactive.text <~ outputs.profileDescription

        profileView.nameTextField.reactive.continuousTextValues
            .observeValues { [weak self] name in
                self?.viewModel.inputs.nameChanged(name)
            }

        profileView.descriptionTextField.reactive.continuousTextValues
            .observeValues { [weak self] description in
                self?.viewModel.inputs.descriptionChanged(description)
            }

        outputs.displayError.startWithValues { [weak self] error in
            self?.presentError(title: error.title, message: error.message)
        }
    }
}
