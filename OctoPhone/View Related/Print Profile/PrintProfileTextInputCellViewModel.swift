//
//  PrintProfileTextInputCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Inputs from cell
protocol PrintProfileTextInputCellViewModelInputs {
    /// Call when user changed
    ///
    /// - Parameter text: New text value
    func textValueChanged(_ text: String?)
}

// MARK: - Outputs

/// Outputs for text cell
protocol PrintProfileTextInputCellViewModelOutputs {
    var descriptionText: Property<String> { get }
}

// MARK: - Common public interface

/// Common protocol for text cell logic
protocol PrintProfileTextInputCellViewModelType {
    /// Available inputs
    var inputs: PrintProfileTextInputCellViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfileTextInputCellViewModelOutputs { get }
}

// MARK: - View Model implementation

final class PrintProfileTextInputCellViewModel: PrintProfileTextInputCellViewModelType, PrintProfileTextInputCellViewModelInputs, PrintProfileTextInputCellViewModelOutputs {
    var inputs: PrintProfileTextInputCellViewModelInputs { return self }

    var outputs: PrintProfileTextInputCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let descriptionText: Property<String>

    // MARK: Private properties

    // MARK: Initializers

    init(description: String) {
        self.descriptionText = Property(value: description)
    }

    // MARK: Input methods

    func textValueChanged(_ text: String?) {
        print("input: \(text)")
    }

    // MARK: Output methods

    // MARK: Internal logic
}
