//
//  PrintProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

/// Print profile detail flow controller
protocol PrintProfileViewControllerDelegate: class {
    /// Called when user tapped done button
    func doneButtonTapped()

    /// Called when user tapped close button
    func closeButtonTapped()
}

/// Print profile detail controller
class PrintProfileViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: PrintProfileViewModelType!

    /// Button for done action
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: self.viewModel.outputs.doneButtonType.value,
                                     target: self, action: #selector(doneButtonTapped))

        return button
    }()

    /// Button for close action
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                     target: self, action: #selector(closeButtonTapped))

        return button
    }()

    /// Input for profile name
    private weak var nameField: FormTextInputView!

    /// Input for profile identifier
    private weak var identifierField: FormTextInputView!

    /// Input for printer model
    private weak var modelField: FormTextInputView!

    // MARK: - Initializers

    convenience init(viewModel: PrintProfileViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        let nameField = FormTextInputView()
        let identifierField = FormTextInputView()
        let modelField = FormTextInputView()

        let formInputs = [nameField, identifierField, modelField]

        let scrollView = UIScrollView()
        let stackView = UIStackView(arrangedSubviews: formInputs, axis: .vertical)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.contentOffset.y = navigationController?.navigationBar.frame.height ?? 0.0
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        self.nameField = nameField
        self.identifierField = identifierField
        self.modelField = modelField

        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        nameField.textField.reactive.continuousTextValues.signal.observeValues { [weak self] text in
            self?.viewModel.inputs.profileNameChanged(text)
        }
        identifierField.textField.reactive.continuousTextValues.signal.observeValues { [weak self] text in
            self?.viewModel.inputs.profileIdentifierChanged(text)
        }
        modelField.textField.reactive.continuousTextValues.signal.observeValues { [weak self] text in
            self?.viewModel.inputs.profileModelChanged(text)
        }

        nameField.descriptionLabel.reactive.text <~ viewModel.outputs.profileNameDescription
        nameField.textField.reactive.text <~ viewModel.outputs.profileNameValue
        identifierField.descriptionLabel.reactive.text <~ viewModel.outputs.profileIdentifierDescription
        identifierField.textField.reactive.text <~ viewModel.outputs.profileIdentifierValue
        modelField.descriptionLabel.reactive.text <~ viewModel.outputs.profileModelDescription
        modelField.textField.reactive.text <~ viewModel.outputs.profileModelValue

        identifierField.textField.reactive.isEnabled <~ viewModel.outputs.profileIdentifierIsEditable

        doneButton.reactive.isEnabled <~ viewModel.outputs.doneButtonIsEnabled

        if viewModel.outputs.closeButtonIsHidden.value {
            navigationItem.leftBarButtonItem = nil
        }

        viewModel.outputs.displayError.startWithValues { [weak self] error in
            self?.presentError(title: error.title, message: error.message)
        }
    }

    /// Done button action callback
    func doneButtonTapped() {
        viewModel.inputs.doneButtonTapped()
    }

    /// Close button action callback
    func closeButtonTapped() {
        viewModel.inputs.closeButtonTapped()
    }
}
