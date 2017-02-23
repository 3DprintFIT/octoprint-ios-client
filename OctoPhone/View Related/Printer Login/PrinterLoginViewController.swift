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

    /// Configured data context
    private let contextManager: ContextManager

    /// Printer URL text field
    private let urlField = UITextField()

    /// User's access token for printer
    private let tokenField = UITextField()

    /// Login button
    private let loginButton = UIButton(type: .system)

    /// Printer login view model
    private let viewModel: PrinterLoginViewModelType = PrinterLoginViewModel()

    /// UI sizes contastants
    struct Sizes {
        /// Spacing from top of the screen
        static let groupTopSpacing: CGFloat = 50
        /// Text input width
        static let textFieldWidth: CGFloat = 180
        /// Unified form field height
        static let fieldheight: CGFloat = 44
        /// Space between fields
        static let fieldSpacing: CGFloat = 15
    }

    /// Creates new PrinterAuthViewController instance
    ///
    /// - Parameter contextManager: Data context dependency - used
    ///   to create new Printer object
    init(contextManager: ContextManager) {
        self.contextManager = contextManager

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
    }

    //MARK - UI callbacks

    /// Closes current controller
    func closeController() {
        dismiss(animated: true, completion: nil)
    }

    //MARK - Private functions

    /// Configures all subviews
    private func configureView() {
        let components = [urlField, tokenField, loginButton]

        components.forEach { component in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(closeController))

        let constraints = [
            urlField.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Sizes.groupTopSpacing
            ),
            urlField.widthAnchor.constraint(equalToConstant: Sizes.textFieldWidth),
            urlField.heightAnchor.constraint(equalToConstant: Sizes.fieldSpacing),
            urlField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tokenField.topAnchor.constraint(
                equalTo: urlField.bottomAnchor,
                constant: Sizes.fieldSpacing
            ),
            tokenField.widthAnchor.constraint(equalTo: urlField.widthAnchor),
            tokenField.heightAnchor.constraint(equalTo: urlField.heightAnchor),
            tokenField.centerXAnchor.constraint(equalTo: urlField.centerXAnchor),

            loginButton.topAnchor.constraint(
                equalTo: tokenField.bottomAnchor,
                constant: Sizes.fieldSpacing
            ),
            loginButton.centerXAnchor.constraint(equalTo: urlField.centerXAnchor)
        ]

        constraints.forEach { $0.isActive = true }

        urlField.placeholder = tr(.printerURL)
        tokenField.placeholder = tr(.printerAccessToken)
        loginButton.setTitle(tr(.login), for: .normal)

        edgesForExtendedLayout = []

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
}
