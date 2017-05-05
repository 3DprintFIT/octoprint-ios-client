//
//  ConnectPrinterViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Printer connection inputs
protocol ConnectPrinterViewModelInputs {
    /// Call when user tapped on close controller button
    func closeButtonTapped()

    /// Call when user selected connection at specific index
    ///
    /// - Parameter index: Index of selected connection
    func selectedConnection(at index: Int)

    /// Call when user decided to connect to selected printer
    func connect()
}

// MARK: - Outputs

/// Printer connection outputs
protocol ConnectPrinterViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Total count of available connections
    var availableConnectionsCount: Int { get }

    /// Indicates whether the user is allowed to selected connection
    var selectionIsEnabled: Property<Bool> { get }

    /// Stream of data changes
    var connectionsChanged: SignalProducer<(), NoError> { get }

    /// Stream of errors presentable to the user
    var displayError: SignalProducer<DisplayableError, NoError> { get }

    /// Generates text label for connection at given index
    ///
    /// - Parameter index: Index of connection in collection
    /// - Returns: Connection label text
    func connectionLabel(at index: Int) -> String
}

// MARK: - Common public interface

/// Printer connection logic common interface
protocol ConnectPrinterViewModelType {
    /// Available inputs
    var inputs: ConnectPrinterViewModelInputs { get }

    /// Available outputs
    var outputs: ConnectPrinterViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Printer connection logic
final class ConnectPrinterViewModel: ConnectPrinterViewModelType, ConnectPrinterViewModelInputs,
ConnectPrinterViewModelOutputs {

    var inputs: ConnectPrinterViewModelInputs { return self }

    var outputs: ConnectPrinterViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property(value: tr(.connectPrinter))

    var availableConnectionsCount: Int {
        // Return 1 for placeholder text
        return selectionIsEnabled.value ? connectionsProperty.value.count : 1
    }

    let selectionIsEnabled: Property<Bool>

    let connectionsChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Currently selected connection index
    private let selectedConnectionProperty = MutableProperty<String?>(nil)

    /// Collection of available connections
    private let connectionsProperty = MutableProperty<[String]>([])

    /// Holds last error occured
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Octoprint requests provider
    private let provider: OctoPrintProvider

    /// Printer connection controller delegate
    private weak var delegate: ConnectPrinterViewControllerDelegate?

    // MARK: Initializers

    init(delegate: ConnectPrinterViewControllerDelegate, provider: OctoPrintProvider) {
        self.delegate = delegate
        self.provider = provider

        self.displayError = displayErrorProperty.producer.skipNil()
        self.connectionsChanged = connectionsProperty.producer.ignoreValues()
        self.selectionIsEnabled = Property(initial: false,
                                           then: connectionsProperty.producer.map({ $0.count > 0 }))

        requestConnections()
    }

    // MARK: Input methods

    func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }

    func selectedConnection(at index: Int) {
        selectedConnectionProperty.value = connectionsProperty.value[index]
    }

    func connect() {
        guard let port = selectedConnectionProperty.value else {
            displayErrorProperty.value = (tr(.anErrorOccured), tr(.noConnectionSelected))
            return
        }

        provider.request(.connectToPort(port))
            .filterSuccessfulStatusAndRedirectCodes()
            .startWithResult { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.closeButtonTapped()
                case .failure:
                    self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                        tr(.selectedPortCouldNotBeConnected))
                }
            }
    }

    // MARK: Output methods

    func connectionLabel(at index: Int) -> String {
        if !selectionIsEnabled.value {
            return tr(.notConnectionAvailable)
        }

        return connectionsProperty.value[index]
    }

    // MARK: Internal logic

    /// Requests list of available connections from printer
    private func requestConnections() {
        provider.request(.listConnections)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .startWithResult { [weak self] result in
                switch result {
                case let .success(data): self?.unwrapConnections(data: data)
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.cannotLoadListOfConnections))
                }
            }
    }

    /// Unwraps list of connections from OP response
    ///
    /// - Parameter data: Raw response data
    private func unwrapConnections(data: Any) {
        guard
            let json = data as? [String: [String: Any]],
            let ports = json["options"]?["ports"] as? [String]
        else {
            displayErrorProperty.value = (tr(.anErrorOccured),
                                          tr(.cannotLoadListOfConnections))

            return
        }

        connectionsProperty.value = ports
    }
}
