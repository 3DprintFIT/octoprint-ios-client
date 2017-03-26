//
//  LogDetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 26/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Log detail inputs
protocol LogDetailViewModelInputs {

}

// MARK: - Outputs

/// Log detail outputs
protocol LogDetailViewModelOutputs {
    /// Stream of log detail errors
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }
}

// MARK: - Common public interface

/// Common interface for log detail view model
protocol LogDetailViewModelType {
    /// Available inputs
    var inputs: LogDetailViewModelInputs { get }

    /// Available outputs
    var outputs: LogDetailViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Log detail manipulation logic
final class LogDetailViewModel: LogDetailViewModelType, LogDetailViewModelInputs,
LogDetailViewModelOutputs {

    var inputs: LogDetailViewModelInputs { return self }

    var outputs: LogDetailViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Log detail
    private let logProperty = MutableProperty<Log?>(nil)

    /// Last occured error which should be presented to user
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(logID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.producer.skipNil()
    }

    // MARK: Input methods
}
