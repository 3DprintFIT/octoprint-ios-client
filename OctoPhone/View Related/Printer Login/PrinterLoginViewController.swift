//
//  PrinterLoginViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

/// Interface for flow delegate
protocol PrinterLoginViewControllerDelegate: class {
    /// Called when user cancels login flow
    func didCancelLogin()

    /// Called when user is successfully logged to selected printer
    func successfullyLoggedIn()
}

/// Gives user ability to add new printer
final class PrinterLoginViewController: BaseViewController {
    /// User-friendly name of printer
    private let printerNameField = PrinterLoginViewController.inputField(placeholder: .printerName)

    /// Printer URL text field
    private let urlField = PrinterLoginViewController.inputField(placeholder: .printerURL)

    /// User's access token for printer
    private let tokenField = PrinterLoginViewController.inputField(placeholder: .printerAccessToken)

    /// Print sream URL
    private let printStreamField = PrinterLoginViewController.inputField(placeholder: .streamURL)

    /// Login button
    private let loginButton = UIButton(type: .system)

    /// Printer login view model
    private var viewModel: PrinterLoginViewModelType!

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
    convenience init(viewModel: PrinterLoginViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    /// Standard library API - setups controller
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        viewModel.inputs.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWillAppear()
    }

    // MARK: - UI callbacks

    /// Closes current controller
    func didTapCancel() {
        viewModel.inputs.cancelLoginPressed()
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
                                                            action: #selector(didTapCancel))

        let stackView = UIStackView(arrangedSubviews: [printerNameField, urlField, tokenField,
                                                       printStreamField, loginButton],
                                    axis: .vertical)

        stackView.distribution = .equalCentering

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
            make.width.equalToSuperview()
        }

        loginButton.setTitle(tr(.login), for: .normal)

        edgesForExtendedLayout = []

        printerNameField.reactive.text <~ viewModel.outputs.namePreset
        urlField.reactive.text <~ viewModel.outputs.addressPreset

        printerNameField.reactive.continuousTextValues.observeValues { [weak self] name in
            self?.viewModel.inputs.printerNameChanged(name)
        }

        urlField.reactive.continuousTextValues.observeValues { [weak self] url in
            self?.viewModel.inputs.printerUrlChanged(url)
        }

        tokenField.reactive.continuousTextValues.observeValues { [weak self] token in
            self?.viewModel.inputs.tokenChanged(token)
        }

        printStreamField.reactive.continuousTextValues.observeValues { [weak self] streamUrl in
            self?.viewModel.inputs.streamUrlChanged(streamUrl)
        }

        loginButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.loginButtonPressed()
        }

        loginButton.reactive.isEnabled <~ viewModel.outputs.isFormValid

        reactive.displayableError <~ viewModel.outputs.displayError
    }
    // swiftlint:enable function_body_length

    /// Preconfigured input field
    ///
    /// - Parameter placeholder: Input placeholder
    /// - Returns: Preconfigured field
    private static func inputField(placeholder: L10n) -> UITextField {
        let field = UITextField()

        field.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        field.placeholder = tr(placeholder)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none

        return field
    }
}
