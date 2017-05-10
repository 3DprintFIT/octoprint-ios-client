//
//  NetworkPrinterCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Cell inputs
protocol NetworkPrinterCellViewModelInputs {

}

// MARK: - Outputs

/// Cell logic outputs
protocol NetworkPrinterCellViewModelOutputs {
    /// Network address of the printer
    var address: Property<String> { get }

    /// Network name of the printer
    var name: Property<String> { get }
}

// MARK: - Common public interface

/// Common interface pro network printer cell
protocol NetworkPrinterCellViewModelType {
    /// Available inputs
    var inputs: NetworkPrinterCellViewModelInputs { get }

    /// Available outputs
    var outputs: NetworkPrinterCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Network printer cell logic
final class NetworkPrinterCellViewModel: NetworkPrinterCellViewModelType,
NetworkPrinterCellViewModelInputs, NetworkPrinterCellViewModelOutputs {

    var inputs: NetworkPrinterCellViewModelInputs { return self }

    var outputs: NetworkPrinterCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    var address: Property<String>

    var name: Property<String>

    // MARK: Private properties

    // MARK: Initializers

    init(networkPrinter: BonjourService) {
        self.address = Property(value: networkPrinter.fullAddress)
        self.name = Property(value: networkPrinter.name)
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
