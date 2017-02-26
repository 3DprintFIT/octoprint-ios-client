//
//  PrinterLoginViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveSwift
import ReactiveCocoa

/// Gives user ability to add new printer
final class PrinterLoginViewController: UIViewController {

    /// User-friendly name of printer
    private let printerNameField = UITextField()

    /// Printer URL text field
    private let urlField = UITextField()

    /// User's access token for printer
    private let tokenField = UITextField()

    /// Login button
    private let loginButton = UIButton(type: .system)

    /// Printer login view model
    private let viewModel: PrinterLoginViewModelType

    /// UI sizes contastants
    struct Sizes {
        /// Spacing from top of the screen
        static let groupTopSpacing: CGFloat = 50
        /// Text input width
        static let textFieldWidth: CGFloat = 180
        /// Unified form field height
        static let fieldheight: CGFloat = 21
        /// Space between fields
        static let fieldSpacing: CGFloat = 12
    }

    /// Creates new PrinterAuthViewController instance
    ///
    /// - Parameter contextManager: Data context dependency - used
    ///   to create new Printer object
    init(viewModel: PrinterLoginViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    /// Legacy required initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Standard library API - setups controller
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        viewModel.inputs.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }

    // MARK: - UI callbacks

    /// Closes current controller
    func closeController() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private functions

    /// Configures all subviews
    // swiftlint:disable function_body_length
    private func configureView() {
        let components = [printerNameField, urlField, tokenField, loginButton]

        components.forEach { component in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(closeController))

        let constraints = [
            printerNameField.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Sizes.groupTopSpacing
            ),
            printerNameField.widthAnchor.constraint(equalToConstant: Sizes.textFieldWidth),
            printerNameField.heightAnchor.constraint(equalToConstant: Sizes.fieldheight),
            printerNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            urlField.topAnchor.constraint(
                equalTo: printerNameField.bottomAnchor,
                constant: Sizes.fieldSpacing
            ),
            urlField.widthAnchor.constraint(equalToConstant: Sizes.textFieldWidth),
            urlField.heightAnchor.constraint(equalTo: printerNameField.heightAnchor),
            urlField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tokenField.topAnchor.constraint(
                equalTo: urlField.bottomAnchor,
                constant: Sizes.fieldSpacing
            ),
            tokenField.widthAnchor.constraint(equalTo: urlField.widthAnchor),
            tokenField.heightAnchor.constraint(equalTo: printerNameField.heightAnchor),
            tokenField.centerXAnchor.constraint(equalTo: urlField.centerXAnchor),

            loginButton.topAnchor.constraint(
                equalTo: tokenField.bottomAnchor,
                constant: Sizes.fieldSpacing
            ),
            loginButton.centerXAnchor.constraint(equalTo: urlField.centerXAnchor)
        ]

        constraints.forEach { $0.isActive = true }

        printerNameField.placeholder = tr(.printerName)
        urlField.placeholder = tr(.printerURL)
        tokenField.placeholder = tr(.printerAccessToken)
        loginButton.setTitle(tr(.login), for: .normal)

        edgesForExtendedLayout = []

        printerNameField.reactive.continuousTextValues.observeValues { [weak self] name in
            self?.viewModel.inputs.printerNameChanged(name)
        }

        urlField.reactive.continuousTextValues.observeValues { [weak self] url in
            self?.viewModel.inputs.printerUrlChanged(url)
        }

        tokenField.reactive.continuousTextValues.observeValues { [weak self] token in
            self?.viewModel.inputs.tokenChanged(token)
        }

        loginButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.loginButtonPressed()
        }

        loginButton.reactive.isEnabled <~ viewModel.outputs.isFormValid
    }
    // swiftlint:enable function_body_length
}
