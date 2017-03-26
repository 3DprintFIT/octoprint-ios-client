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
    func
}

// MARK: - Outputs

/// Outputs from view model
protocol LogsViewModelOutputs {
    /// Total count of logs
    var logsCount: Int { get }

    /// Logs change notification stream
    var logsListChanged: SignalProducer<(), NoError> { get }

    /// Produces errors which should be propagated to the user
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }

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

    var logsCount: Int { return logsProperty.value?.count ?? 0 }

    let logsListChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connections manager
    private let contextManager: ContextManagerType

    /// List of logs currently stored in database
    private let logsProperty = MutableProperty<Results<Log>?>(nil)

    /// Holds last occured error, redirects errors to output
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.provider = provider
        self.contextManager = contextManager
        self.logsListChanged = logsProperty.producer.ignoreValues()
        self.displayError = displayErrorProperty.producer.skipNil()

        contextManager.createObservableContext()
            .fetch(collectionOf: Log.self)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(logs): self?.logsProperty.value = logs
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.storedLogsCouldNotBeLoaded))
                }
        }

        downloadLogList()
    }

    // MARK: Input methods

    // MARK: Output methods

    func logCellViewModel(for index: Int) -> LogCellViewModelType {
        assert(logsProperty.value != nil)

        let log = logsProperty.value![index]

        return LogCellViewModel(log: log)
    }

    // MARK: Internal logic

    /// Requests logs list from printer
    private func downloadLogList() {
        provider.request(.logs)
            .mapJSON()
            .mapTo(collectionOf: Log.self, forKeyPath: "files")
            .startWithResult {[weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(logs):
                    do {
                        let realm = try weakSelf.contextManager.createContext()

                        try realm.write {
                            realm.add(logs, update: true)
                        }
                    } catch {
                        weakSelf.displayErrorProperty.value = (tr(.databaseError),
                                                               tr(.couldNotSaveDownloadedListOfLogs))
                    }
                case .failure:
                    self?.displayErrorProperty.value = (tr(.connectionError),
                                                        tr(.logsCouldNotBeDownloadedFromPrinter))
                }
        }
    }
}
