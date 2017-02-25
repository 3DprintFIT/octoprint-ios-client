//
//  PrinterLoginViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

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

    /// Call when login button is pressed
    func loginButtonPressed()
}

protocol PrinterLoginViewModelOutputs {
    /// Bool value for form validation
    var isFormValid: Signal<Bool, NoError> { get }
}

protocol PrinterLoginViewModelType: PrinterLoginViewModelInputs, PrinterLoginViewModelOutputs {
    /// View model inputs
    var inputs: PrinterLoginViewModelInputs { get }

    /// View model outputs
    var outputs: PrinterLoginViewModelOutputs { get }
}

final class PrinterLoginViewModel: PrinterLoginViewModelType {

    var inputs: PrinterLoginViewModelInputs { return self }

    var outputs: PrinterLoginViewModelOutputs { return self }

    // MARK: Outputs

    let isFormValid: Signal<Bool, NoError>

    // MARK: Properties

    /// Model property for printer name
    private let printerNameProperty = MutableProperty<String?>(nil)

    /// Model property for printer URL
    private let printerUrlProperty = MutableProperty<String?>(nil)

    /// Model property for printer login token
    private let tokenProperty = MutableProperty<String?>(nil)

    /// Model property for button press action
    private let loginButtonPressedProperty = MutableProperty(())

    /// Model property for view did load action
    private let viewDidLoadProperty = MutableProperty(())

    /// Model property for view will appear action
    private let viewWillAppearProperty = MutableProperty(())

    init() {
        let formValues = Signal.combineLatest(
            printerNameProperty.signal.skipNil(),
            printerUrlProperty.signal.skipNil(),
            tokenProperty.signal.skipNil()
        )

        isFormValid = Signal.merge([
            viewWillAppearProperty.signal.map({ _ in false }).take(first: 1),
            formValues.map(PrinterLoginViewModel.isValid)
        ])

        loginButtonPressedProperty.signal
            .combineLatest(with: formValues)
            .map({ $0.1 })
            .observeValues { name, url, token in
                print("logon to \(url) with token \(token) named: \(name)")
            }
    }

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

    func loginButtonPressed() {
        loginButtonPressedProperty.value = ()
    }

    // MARK: Private functions

    /// Validate form values
    ///
    /// - Parameters:
    ///   - name: User-friendly printer name
    ///   - url: Printer base URL path
    ///   - token: Access token
    /// - Returns: True if form values are valid
    private static func isValid(_ name: String, _ url: String, token: String) -> Bool {
        guard let url = URL(string: url) else { return false }

        return !name.characters.isEmpty && !url.absoluteString.characters.isEmpty
            && !url.isFileURL && !token.characters.isEmpty
    }
}
