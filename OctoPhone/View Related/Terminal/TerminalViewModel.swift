//
//  TerminalViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift
import Result

/// Terminal inputs
protocol TerminalViewModelInputs {
    /// Call when user pressed the send button
    func sendButtonPressed()

    /// Call when command changed
    ///
    /// - Parameter command: New command
    func commandChanged(_ command: String?)
}

/// Terminal outputs
protocol TerminalViewModelOutputs {
    /// Enables send button based on command validity
    var isCommandValid: SignalProducer<Bool, NoError> { get }

    /// Stream of occured errors
    var displayError: Signal<DisplayableError, NoError> { get }

    /// Total count of created commands
    var commandsCount: Int { get }

    /// Emits whenever commands count is changed
    var commandsChanged: SignalProducer<(), NoError> { get }

    func commandCellViewModel(for index: Int) -> CommandCellViewModel
}

/// Common interface for terminal view model
protocol TerminalViewModelType {
    /// Available terminal inputs
    var inputs: TerminalViewModelInputs { get }

    /// Available terminal outputs
    var outputs: TerminalViewModelOutputs { get }
}

/// Terminal controller logic
final class TerminalViewModel: TerminalViewModelType, TerminalViewModelInputs,
TerminalViewModelOutputs {

    var inputs: TerminalViewModelInputs { return self }

    var outputs: TerminalViewModelOutputs { return self }

    // MARK: Outputs

    let isCommandValid: SignalProducer<Bool, NoError>

    let displayError: Signal<DisplayableError, NoError>

    var commandsCount: Int { return commandsProperty.value?.count ?? 0 }

    var commandsChanged: SignalProducer<(), NoError>

    // MARK: Private properties

    /// Printer command value
    private let commandProperty = MutableProperty<String?>(nil)

    /// Stores information about send button pressed action
    private let sendButtonPressedProperty = MutableProperty<Void>(())

    /// Collection of terminal commands send to printer
    private var commandsProperty = MutableProperty<Results<Command>?>(nil)

    /// Creates output error signal
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    init(provider: OctoPrintProvider, contextManager: ContextManagerType) {
        let commandValue = commandProperty.producer.skipNil()

        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.signal.skipNil()
        self.commandsChanged = commandsProperty.producer.skipNil().ignoreValues()

        self.isCommandValid = SignalProducer.merge(
            SignalProducer<Bool, NoError>.init(value: false),
            commandValue.map({ !$0.isEmpty })
        )

        contextManager.createObservableContext()
            .fetch(collectionOf: Command.self)
            .startWithResult({ [weak self] result in
                switch result {
                case let .success(printers): self?.commandsProperty.value = printers
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.canNotLoadStoredCommands))
                }
            })

        commandValue
            .sample(on: sendButtonPressedProperty.signal)
            .map({ Command(value: $0, status: .processing) })
            .startWithValues { [weak self] command in
                guard let weakSelf = self else { return }

                do {
                    let realm = try weakSelf.contextManager.createContext()
                    try realm.write {
                        realm.add(command)
                    }
                } catch {
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.canNotCreateRequestedCommand))
                }
        }
    }

    // MARK: Inputs

    func sendButtonPressed() {
        sendButtonPressedProperty.value = ()
    }

    func commandChanged(_ command: String?) {
        commandProperty.value = command
    }

    // MARK: Output methods
    func commandCellViewModel(for index: Int) -> CommandCellViewModel {
        assert(commandsProperty.value != nil,
               "Commands must not be nil when requesting cell for specific command.")

        let command = commandsProperty.value![index]

        return CommandCellViewModel(provider: provider, contextManager: contextManager, command: command)
    }
}
