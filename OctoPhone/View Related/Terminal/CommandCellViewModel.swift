//
//  CommandCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import RealmSwift
import ReactiveSwift
import Result
import ReactiveMoya

// MARK: - Inputs

/// Command cell logic inputs
protocol CommandCellViewModelInputs {

}

// MARK: - Outputs

/// Command cell logic outputs
protocol CommandCellViewModelOutputs {
    /// Actual command value entered by user
    var commandValue: SignalProducer<String, NoError> { get }

    /// Stream of errors occured o
    var displayError: Signal<(title: String, message: String), NoError> { get }
}

// MARK: - Common public interface

/// Command cell logic common interface
protocol CommandCellViewModelType {
    /// Available inputs
    var inputs: CommandCellViewModelInputs { get }

    /// Available outputs
    var outputs: CommandCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Command cell logic
/// Sends command to the printer. When the command is not processed
/// while the command cell is on screen, the command is canceled and will be
/// processed once the command is back on the screen.
final class CommandCellViewModel: CommandCellViewModelType, CommandCellViewModelInputs,
CommandCellViewModelOutputs {

    var inputs: CommandCellViewModelInputs { return self }

    var outputs: CommandCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs
    let commandValue: SignalProducer<String, NoError>

    let displayError: Signal<(title: String, message: String), NoError>

    // MARK: Private properties
    private let commandValueProperty = MutableProperty<String?>(nil)

    /// Command send to the printer
    private let command: Command

    /// Printer connection provider
    private let provider: OctoPrintProvider

    /// Database donnection manager
    private let contextManager: ContextManagerType

    /// Allows to cancel command request when view model is deallocated
    private var requestDisposable: Disposable?

    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(provider: OctoPrintProvider, contextManager: ContextManagerType, command: Command) {
        self.provider = provider
        self.contextManager = contextManager
        self.command = command
        self.commandValue = commandValueProperty.producer.skipNil()
        self.displayError = displayErrorProperty.signal.skipNil()

        commandValueProperty.value = command.value

        if command.status == .processing {
            performCommand()
        }
    }

    private func performCommand() {
        let commandReference = ThreadSafeReference(to: command)

        requestDisposable = provider.request(.sendCommand(command.value))
            .filterSuccessfulStatusCodes()
            .startWithResult({ [weak self] result in
                guard let weakSelf = self else { return }

                let status: CommandStatus

                switch result {
                case .success: status = .success
                case .failure:
                    weakSelf.displayErrorProperty.value = ("", "")
                    status = .failed
                }

                do {
                    let realm = try weakSelf.contextManager.createContext()

                    guard let command = realm.resolve(commandReference) else { return }

                    try realm.write {
                        command.status = status
                    }
                } catch { }
            })
    }

    deinit {
        requestDisposable?.dispose()
    }
}
