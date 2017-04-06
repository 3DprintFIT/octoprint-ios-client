//
//  PrintProfileViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Print profile detail inputs
protocol PrintProfileViewModelInputs {

}

// MARK: - Outputs

/// Print profile logic output
protocol PrintProfileViewModelOutputs {
    /// Profile name input description
    var profileNameDescription: Property<String> { get }

    /// Profile name default value
    var profileNameValue: Property<String?> { get }

    /// Profile identifier input description
    var profileIdentifierDescription: Property<String> { get }

    /// Profile identifier default value
    var profileIdentifierValue: Property<String?> { get }

    /// Profile model input descripiton
    var profileModelDescription: Property<String> { get }

    /// Profile model default value
    var profileModelValue: Property<String?> { get }
}

// MARK: - Common public interface

/// Common protocol for print profile logic
protocol PrintProfileViewModelType {
    /// Available inputs
    var inputs: PrintProfileViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfileViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Print profile detail logic
final class PrintProfileViewModel: PrintProfileViewModelType, PrintProfileViewModelInputs,
PrintProfileViewModelOutputs {
    var inputs: PrintProfileViewModelInputs { return self }

    var outputs: PrintProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let profileNameDescription = Property<String>(value: tr(.printProfileName))

    /// Profile name default value
    let profileNameValue: Property<String?>

    /// Profile identifier input description
    let profileIdentifierDescription = Property<String>(value: tr(.printProfileIdentifier))

    /// Profile identifier default value
    let profileIdentifierValue: Property<String?>

    /// Profile model input descripiton
    let profileModelDescription = Property<String>(value: tr(.printProfileModel))

    /// Profile model default value
    let profileModelValue: Property<String?>

    // MARK: Private properties

    /// identifier of print profile
    private let printProfileID: String

    /// Printer request provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual printer profile
    private let printProfileProperty = MutableProperty<PrinterProfile?>(nil)

    // MARK: Initializers

    init(printProfileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.printProfileID = printProfileID
        self.provider = provider
        self.contextManager = contextManager

        self.profileNameValue = Property(initial: nil,
                                         then: printProfileProperty.producer.map({ $0?.name }))
        self.profileIdentifierValue = Property(initial: nil,
                                               then: printProfileProperty.producer.map({ $0?.ID }))
        self.profileModelValue = Property(initial: nil,
                                          then: printProfileProperty.producer.map({ $0?.model }))

        contextManager.createObservableContext()
            .fetch(PrinterProfile.self, forPrimaryKey: printProfileID)
            .skipError()
            .startWithValues { [weak self] profile in
                self?.printProfileProperty.value = profile
            }
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
