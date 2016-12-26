//
//  PrinterLoginViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import RealmSwift

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

    /// User action handler for login tapped action
    func login() {
        validateForm()
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeController))

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

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        edgesForExtendedLayout = []
    }

    /// Validates inputs from user, creates auth request if valid
    private func validateForm() {
        guard let urlString = urlField.text, let token = tokenField.text else {
            print("Form fields must be filled in.")
            return
        }

        guard let printerURL = URL(string: urlString), token.characters.count > 2 else {
            print("Form values are not valid.")
            return
        }

        let printerController = PrinterController(
            printerURL: printerURL,
            contextManager: contextManager
        )

        let authPromise = printerController.autheticate(with: token)

        authPromise.finishedWithResult = handleLogin
    }

    /// Handles authentication request result
    ///
    /// - Parameter result: Authentication request result
    private func handleLogin(result: AuthenticationPromise.AuthenticationResult) {
        switch result {
        case .success: print("Logged in")
        case .unauthorized: print("Access token not valid")
        case .connectionFailed: print("Uknown connection error")
        }
    }
}
