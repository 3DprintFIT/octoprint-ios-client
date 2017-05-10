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

/// Inputs for login logic
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

/// Outputs of login logic
protocol PrinterLoginViewModelOutputs {
    /// Initial name of printer
    var namePreset: ReactiveSwift.Property<String?> { get }

    /// Initial address of printer
    var addressPreset: ReactiveSwift.Property<String?> { get }

    /// Bool value for form validation
    var isFormValid: SignalProducer<Bool, NoError> { get }

    /// Errors which should be displayed
    var displayError: Signal<DisplayableError, NoError> { get }
}

/// Common interface for login ViewModels
protocol PrinterLoginViewModelType {
    /// View model inputs
    var inputs: PrinterLoginViewModelInputs { get }

    /// View model outputs
    var outputs: PrinterLoginViewModelOutputs { get }
}

/// Login screen logic
final class PrinterLoginViewModel: PrinterLoginViewModelType, PrinterLoginViewModelInputs,
PrinterLoginViewModelOutputs {

    var inputs: PrinterLoginViewModelInputs { return self }

    var outputs: PrinterLoginViewModelOutputs { return self }

    // MARK: Outputs

    let namePreset: ReactiveSwift.Property<String?>

    let addressPreset: ReactiveSwift.Property<String?>

    let isFormValid: SignalProducer<Bool, NoError>

    let displayError: Signal<DisplayableError, NoError>

    // MARK: Properties

    /// Model property for printer name
    private let printerNameProperty: MutableProperty<String?>

    /// Model property for printer URL
    private let printerUrlProperty: MutableProperty<String?>

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
    init(delegate: PrinterLoginViewControllerDelegate, contextManager: ContextManagerType,
         service: BonjourService? = nil) {

        self.delegate = delegate
        self.contextManager = contextManager
        self.namePreset = Property(value: service?.name)
        self.addressPreset = Property(value: service?.fullAddress)

        // Set the initial values also to ViewModel
        printerUrlProperty = MutableProperty(service?.fullAddress)
        printerNameProperty = MutableProperty(service?.name)

        let formValues = SignalProducer.combineLatest(
            printerNameProperty.producer.skipNil(),
            printerUrlProperty.producer.skipNil(),
            tokenProperty.producer.skipNil(),
            streamUrlProperty.producer
        )

        // Dirty hack to make stream URL optional
        streamUrlProperty.value = nil

        displayError = displayErrorProperty.signal.skipNil()

        isFormValid = SignalProducer.merge([
            viewWillAppearProperty.producer.map({ _ in false }).take(first: 1),
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
        loginEvent
            .map({ $0.event.value })
            .skipNil()
            .startWithValues { [weak self] printer in
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
        loginEvent
            .map({ $0.event.error })
            .skipNil()
            .startWithValues { [weak self] error in
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
