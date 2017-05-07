//
//  PrinterLoginViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Result
import Moya
import ReactiveSwift
import ReactiveMoya
import RealmSwift

protocol PrinterLoginViewModelInputs {
    /// Call when view did load
    func viewDidLoad()

    /// Call when view will appear on screen
    func viewWillAppear()

    /// Call when printer name is changed
    ///
    /// - Parameter name: New printer name
    func printerNameChanged(_ name: String?)

    /// String value of URL textfield text
    ///
    /// - Parameter url: Entered url text
    func printerUrlChanged(_ url: String?)

    /// String value of token textfield text
    ///
    /// - Parameter token: Entered login token
    func tokenChanged(_ token: String?)

    /// Call when user changed print stream URL
    ///
    /// - Parameter url: Entered stream URL
    func streamUrlChanged(_ url: String?)

    /// Call when login button is pressed
    func loginButtonPressed()

    /// Call when cancel button is tapped
    func cancelLoginPressed()
}

protocol PrinterLoginViewModelOutputs {
    /// Bool value for form validation
    var isFormValid: Signal<Bool, NoError> { get }

    /// Errors which should be displayed
    var displayError: Signal<DisplayableError, NoError> { get }
}

protocol PrinterLoginViewModelType {
    /// View model inputs
    var inputs: PrinterLoginViewModelInputs { get }

    /// View model outputs
    var outputs: PrinterLoginViewModelOutputs { get }
}

final class PrinterLoginViewModel: PrinterLoginViewModelType, PrinterLoginViewModelInputs,
PrinterLoginViewModelOutputs {

    var inputs: PrinterLoginViewModelInputs { return self }

    var outputs: PrinterLoginViewModelOutputs { return self }

    // MARK: Outputs

    let isFormValid: Signal<Bool, NoError>

    let displayError: Signal<DisplayableError, NoError>

    // MARK: Properties

    /// Model property for printer name
    private let printerNameProperty = MutableProperty<String?>(nil)

    /// Model property for printer URL
    private let printerUrlProperty = MutableProperty<String?>(nil)

    /// Model property for printer login token
    private let tokenProperty = MutableProperty<String?>(nil)

    /// Actual value of stream URL
    private let streamUrlProperty = MutableProperty<String?>(nil)

    /// Model property for button press action
    private let loginButtonPressedProperty = MutableProperty(())

    /// Model property for view did load action
    private let viewDidLoadProperty = MutableProperty(())

    /// Model property for view will appear action
    private let viewWillAppearProperty = MutableProperty(())

    /// Requests provider property
    private let providerProperty = MutableProperty<OctoPrintProvider?>(nil)

    /// Error description property
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// View controller delegate
    private weak var delegate: PrinterLoginViewControllerDelegate?

    // swiftlint:disable function_body_length
    init(delegate: PrinterLoginViewControllerDelegate, contextManager: ContextManagerType) {
        self.delegate = delegate
        self.contextManager = contextManager

        let formValues = Signal.combineLatest(
            printerNameProperty.signal.skipNil(),
            printerUrlProperty.signal.skipNil(),
            tokenProperty.signal.skipNil(),
            streamUrlProperty.signal
        )

        // Dirty hack to make stream URL optional
        streamUrlProperty.value = nil

        displayError = displayErrorProperty.signal.skipNil()

        isFormValid = Signal.merge([
            viewWillAppearProperty.signal.map({ _ in false }).take(first: 1),
            formValues.map(PrinterLoginViewModel.isValid)
        ])

        let loginEvent = formValues
            .sample(on: loginButtonPressedProperty.signal)
            .map({ name, url, token, stream -> (Printer, OctoPrintProvider) in
                let printer = Printer(url: URL(string: url)!, accessToken: token, name: name,
                                      streamUrl: URL(string: stream ?? ""))
                let tokenPlugin = TokenPlugin(token: token)
                let provider = OctoPrintProvider(baseURL: printer.url, plugins: [tokenPlugin])

                return (printer, provider)
            })
            .flatMap(.latest) { printer, provider in
                return provider.request(.version)
                    .filterSuccessfulStatusCodes()
                    .map({_ in return printer })
                    .materialize()
        }

        // Observe for successful login
        loginEvent.signal
            .map({ $0.event.value })
            .skipNil()
            .observeValues { [weak self] printer in
                guard let weakSelf = self else { return }

                do {
                    let realm = try weakSelf.contextManager.createContext()

                    try realm.write {
                        realm.add(printer, update: true)
                    }
                } catch { }

                weakSelf.delegate?.successfullyLoggedIn()
        }

        // Observe for errors while logging in
        loginEvent.signal
            .map({ $0.event.error })
            .skipNil()
            .observeValues { [weak self] error in
                if case let .statusCode(response) = error, response.statusCode == 401 {
                    self?.displayErrorProperty.value = (tr(.loginError), tr(.incorrectCredentials))
                } else {
                    self?.displayErrorProperty.value = (tr(.loginError), tr(.couldNotConnectToPrinter))
                }
        }
    }
    // swiftlint:enable function_body_length

    // MARK: Inputs

    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }

    func viewWillAppear() {
        viewWillAppearProperty.value = ()
    }

    func printerNameChanged(_ name: String?) {
        printerNameProperty.value = name
    }

    func printerUrlChanged(_ url: String?) {
        printerUrlProperty.value = url
    }

    func tokenChanged(_ token: String?) {
        tokenProperty.value = token
    }

    func streamUrlChanged(_ url: String?) {
        streamUrlProperty.value = url
    }

    func loginButtonPressed() {
        loginButtonPressedProperty.value = ()
    }

    func cancelLoginPressed() {
        delegate?.didCancelLogin()
    }

    /// Validate form values
    ///
    /// - Parameters:
    ///   - name: User-friendly printer name
    ///   - url: Printer base URL path
    ///   - token: Access token
    /// - Returns: True if form values are valid
    private static func isValid(_ name: String, _ url: String, token: String, stream: String?) -> Bool {
        guard let url = URL(string: url) else { return false }

        return !name.characters.isEmpty && !url.absoluteString.characters.isEmpty
            && !url.isFileURL && !token.characters.isEmpty
    }
}
