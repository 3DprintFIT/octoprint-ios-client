//
//  LogsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import RealmSwift
import ReactiveSwift
import Result

// MARK: - Inputs

/// Inputs from view controller
protocol LogsViewModelInputs {

}

// MARK: - Outputs

/// Outputs from view model
protocol LogsViewModelOutputs {
    /// Total count of logs
    var logsCount: Int { get }

    /// Logs change notification stream
    var logsListChanged: Signal<(), NoError> { get }

    /// Creates view model for given row
    ///
    /// - Parameter index: Selected row of log
    /// - Returns: New cell view model
    func logCellViewModel(for index: Int) -> LogCellViewModelType
}

// MARK: - Common public interface

/// Interface for logs screen
protocol LogsViewModelType {
    /// Available inputs
    var inputs: LogsViewModelInputs { get }

    /// Available outputs
    var outputs: LogsViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Common logic for logs screeen
final class LogsViewModel: LogsViewModelType, LogsViewModelInputs, LogsViewModelOutputs {
    var inputs: LogsViewModelInputs { return self }

    var outputs: LogsViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    var logsCount: Int { return logs?.count ?? 0 }

    let logsListChanged: Signal<(), NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connections manager
    private let contextManager: ContextManagerType

    /// List of logs currently stored in database
    private var logs: Results<Log>?

    /// Realm changes observe token
    private var logsToken: NotificationToken?

    /// Logs change signal and observer
    private let (logsSignal, logsObserver) = Signal<(), NoError>.pipe()

    // MARK: Initializers

    init(provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.provider = provider
        self.contextManager = contextManager
        self.logsListChanged = logsSignal

        do {
            let realm = try contextManager.createContext()

            logs = realm.objects(Log.self)
            logsToken = logs?.addNotificationBlock({ [weak self] _ in
                self?.logsObserver.send(value: ())
            })
        } catch {}
    }

    // MARK: Input methods

    // MARK: Output methods
    func logCellViewModel(for index: Int) -> LogCellViewModelType {
        assert(logs != nil)

        let log = logs![index]

        return LogCellViewModel(log: log)
    }

    deinit {
        logsToken?.stop()
        logsObserver.sendCompleted()
    }
}
