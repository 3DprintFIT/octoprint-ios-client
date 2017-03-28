//
//  LogDetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 26/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import RealmSwift
import Result

// MARK: - Inputs

/// Log detail inputs
protocol LogDetailViewModelInputs {

}

// MARK: - Outputs

/// Log detail outputs
protocol LogDetailViewModelOutputs {
    /// Log file name
    var name: SignalProducer<String, NoError> { get }

    /// Log file size
    var size: SignalProducer<String, NoError> { get }

    /// Formatted date of last modification
    var lastModification: SignalProducer<String, NoError> { get }

    /// Log content, nil if content is not downloaded yet
    var content: SignalProducer<String?, NoError> { get }

    /// Indicates whether the file is being downloaded
    var isDownloadingContent: SignalProducer <Bool, NoError> { get }

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

    let name: SignalProducer<String, NoError>

    let size: SignalProducer<String, NoError>

    let lastModification: SignalProducer<String, NoError>

    let content: SignalProducer<String?, NoError>

    let isDownloadingContent: SignalProducer<Bool, NoError>

    // MARK: Outputs

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Log detail
    private let logProperty = MutableProperty<Log?>(nil)

    /// Emits event to download log when value is assigned
    private let downloadProperty: MutableProperty<()>

    /// Last occured error which should be presented to user
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    /// Keeps state of file downloading
    private let isDownloadingContentProperty = MutableProperty(false)

    /// Realm change notification token
    private var logNotification: NotificationToken?

    // MARK: Initializers

    init(logReference: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.provider = provider
        self.contextManager = contextManager

        let logProducer = logProperty.producer.skipNil()
        let contentProducer = logProperty.producer
            .map { $0?.localPath }
            .map { path -> String? in
                guard let path = path else { return nil }

                let directories = FileManager.default.urls(for: .documentDirectory,
                                                           in: .userDomainMask)

                if !directories.isEmpty {
                    return try? String.init(contentsOf: directories[0].appendingPathComponent(path))
                }

                return nil
            }

        self.name = logProducer.map({ $0.name }).prefix(value: tr(.unknownFile))
        self.size = logProducer.map({ $0.name }).prefix(value: tr(.unknownFileSize))
        self.lastModification = logProducer.map({ $0.name }).prefix(value: tr(.unknownModificationDate))
        self.content = contentProducer.prefix(value: tr(.downloadingLogFile))
        self.isDownloadingContent = isDownloadingContentProperty.producer
        self.displayError = displayErrorProperty.producer.skipNil()
        self.downloadProperty = MutableProperty(())

        do {
            let realm = try contextManager.createContext()
            let log = realm.object(ofType: Log.self, forPrimaryKey: logReference)

            logProperty.value = log
            logNotification = log?.addNotificationBlock({ [weak self] _ in
                self?.logProperty.value = log
            })
        } catch {
            displayErrorProperty.value = (tr(.anErrorOccured), tr(.canNotOpenSelectedLog))
        }

        setupSignals()
    }

    // MARK: Input methods

    // MARK: Internal logic

    /// Configures all internal logic signal
    private func setupSignals() {
        logProperty.producer
            .skipNil()
            .sample(on: downloadProperty.producer)
            .map({ $0.remotePath })
            .flatMap(.latest) { self.provider.request(.downloadLog($0)) }
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                guard let weakSelf = self, let log = weakSelf.logProperty.value else { return }

                if case .failure = result {
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.requestedLogFileCouldNotBeDownloaded))
                    return
                }
                do {
                    let realm = try weakSelf.contextManager.createContext()

                    try realm.write {
                        log.localPath = log.remotePath
                    }
                } catch {
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.requestedLogFileCouldNotBeDownloaded))
                }
            }
    }

    deinit {
        logNotification?.stop()
    }
}
