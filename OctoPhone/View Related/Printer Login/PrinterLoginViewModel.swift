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
    var isFormValid: SignalProducer<Bool, NoError> { get }
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

    let isFormValid: SignalProducer<Bool, NoError>

    // MARK: Properties

    /// Model property for printer URL
    private let printerUrlProperty = MutableProperty<URL?>(nil)

    /// Model property for printer login token
    private let tokenProperty = MutableProperty<String?>(nil)

    init() {
        let urlAndToken = SignalProducer.combineLatest(printerUrlProperty.producer.skipNil(),
                                                       tokenProperty.producer.skipNil())

        isFormValid = urlAndToken.map({ url, token in
            return !url.isFileURL && url.absoluteString.characters.count > 0 &&
                token.characters.count > 0
        })
    }

    // MARK: Inputs

    func printerUrlChanged(_ url: String?) {
        guard let url = url else { printerUrlProperty.value = nil; return }

        printerUrlProperty.value = URL(string: url)
    }

    func tokenChanged(_ token: String?) {
        tokenProperty.value = token
    }

    func loginButtonPressed() {
        print("logging user in")
    }
}
