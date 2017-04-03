//
//  PrintProfileCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Inputs for View Model logic
protocol PrintProfileCellViewModelInputs {

}

// MARK: - Outputs

/// View Model logic output
protocol PrintProfileCellViewModelOutputs {
    /// Name of print profile
    var name: SignalProducer<String, NoError> { get }
}

// MARK: - Common public interface

/// Common protocol for print profile View Model
protocol PrintProfileCellViewModelType {
    /// Available inputs
    var inputs: PrintProfileCellViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfileCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Print profile View Controller logic
final class PrintProfileCellViewModel: PrintProfileCellViewModelType, PrintProfileCellViewModelInputs,
PrintProfileCellViewModelOutputs {
    var inputs: PrintProfileCellViewModelInputs { return self }

    var outputs: PrintProfileCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let name: SignalProducer<String, NoError>

    // MARK: Private properties

    /// Identifier of print profile
    private let printProfileID: String

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual printer profile
    private let printProfileProperty = MutableProperty<PrinterProfile?>(nil)

    // MARK: Initializers

    init(printProfileID: String, contextManager: ContextManagerType) {
        self.printProfileID = printProfileID
        self.contextManager = contextManager

        self.name = printProfileProperty.producer
            .map({ $0?.name })
            .map({ $0 ?? tr(.unknownPrinterProfile) })

        contextManager.createObservableContext()
            .fetch(PrinterProfile.self, forPrimaryKey: printProfileID)
            .startWithResult { [weak self] result in
                if case let .success(profile) = result {
                    self?.printProfileProperty.value = profile
                }
            }
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
