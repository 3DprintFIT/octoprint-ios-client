//
//  LogCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import RealmSwift
import Result

// MARK: - Inputs

/// Inputs from view controller
protocol LogCellViewModelInputs {

}

// MARK: - Outputs

/// Outputs for view controller
protocol LogCellViewModelOutputs {
    /// Name of log file
    var name: SignalProducer<String, NoError> { get }

    /// Size of log file
    var size: SignalProducer<String, NoError> { get }
}

// MARK: - Common public interface

/// Common interface for log cell logic
protocol LogCellViewModelType {
    /// Available inputs
    var inputs: LogCellViewModelInputs { get }

    /// Available outputs
    var outputs: LogCellViewModelOutputs { get }
}

// MARK: - View Model implementation

final class LogCellViewModel: LogCellViewModelType, LogCellViewModelInputs, LogCellViewModelOutputs {
    var inputs: LogCellViewModelInputs { return self }

    var outputs: LogCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let name: SignalProducer<String, NoError>

    let size: SignalProducer<String, NoError>

    // MARK: Private properties

    /// Formatted name property
    private let nameProperty = MutableProperty<String?>(nil)

    /// Formatted size property
    private let sizeProperty = MutableProperty<Int?>(nil)

    /// Current log to be displayed
    private let log: Log

    /// Realm notification token
    private var logToken: NotificationToken?

    // MARK: Initializers

    init(log: Log) {
        self.log = log
        self.name = nameProperty.producer.skipNil()
        self.size = sizeProperty.producer
            .skipNil()
            .formatFileSize()

        self.logToken = log.addNotificationBlock { [weak self] change in
            guard let weakSelf = self else { return }

            if case .change = change {
                weakSelf.nameProperty.value = weakSelf.log.name
                weakSelf.sizeProperty.value = weakSelf.log.size
            }
        }

        // Initial data
        nameProperty.value = log.name
        sizeProperty.value = log.size
    }

    // MARK: Input methods

    deinit {
        self.logToken?.stop()
    }
}
