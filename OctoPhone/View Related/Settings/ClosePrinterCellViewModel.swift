//
//  ClosePrinterCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Button cell inputs
protocol ClosePrinterCellViewModelInputs {
    /// Call when user tapped on close printer button
    func closePrinterButtonTapped()
}

// MARK: - Outputs

/// Cell outputs for both View or Controllers
protocol ClosePrinterCellViewModelOutputs {
    /// Close button text
    var text: Property<String> { get }

    /// Forwards button tap events
    var closePrinterTapped: SignalProducer<(), NoError> { get }
}

// MARK: - Common public interface

/// Common protocol for button cell View Model
protocol ClosePrinterCellViewModelType {
    /// Available inputs
    var inputs: ClosePrinterCellViewModelInputs { get }

    /// Available outputs
    var outputs: ClosePrinterCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Button cell logic
// swiftlint:disable line_length
final class ClosePrinterCellViewModel: ClosePrinterCellViewModelType, ClosePrinterCellViewModelInputs,
ClosePrinterCellViewModelOutputs {
// swiftlint:enable line_length
    var inputs: ClosePrinterCellViewModelInputs { return self }

    var outputs: ClosePrinterCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let text = Property<String>(value: tr(.closePrinter))

    var closePrinterTapped: SignalProducer<(), NoError>

    // MARK: Private properties

    /// Takes button tap evenets and broadcasts them to receivers
    private let closePrinterTappedProperty = MutableProperty<()>(())

    // MARK: Initializers

    init() {
        closePrinterTapped = closePrinterTappedProperty.producer.skip(first: 1)
    }

    // MARK: Input methods

    func closePrinterButtonTapped() {
        closePrinterTappedProperty.value = ()
    }

    // MARK: Output methods

    // MARK: Internal logic
}
