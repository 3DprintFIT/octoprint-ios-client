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
}

// MARK: - Outputs

/// Printer connection outputs
protocol ConnectPrinterViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }
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

    let title = Property(value: "")

    // MARK: Private properties

    /// Octoprint requests provider
    private let provider: OctoPrintProvider

    /// Printer connection controller delegate
    private weak var delegate: ConnectPrinterViewControllerDelegate?

    // MARK: Initializers

    init(delegate: ConnectPrinterViewControllerDelegate, provider: OctoPrintProvider) {
        self.delegate = delegate
        self.provider = provider
    }

    // MARK: Input methods

    func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }

    // MARK: Output methods

    // MARK: Internal logic
}
