//
//  ControlsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

protocol ControlsViewModelInputs {

}

// MARK: - Outputs

protocol ControlsViewModelOutputs {

}

// MARK: - Common public interface

protocol ControlsViewModelType {
    /// Available inputs
    var inputs: ControlsViewModelInputs { get }

    /// Available outputs
    var outputs: ControlsViewModelOutputs { get }
}

// MARK: - View Model implementation

final class ControlsViewModel: ControlsViewModelType, ControlsViewModelInputs, ControlsViewModelOutputs {
    var inputs: ControlsViewModelInputs { return self }

    var outputs: ControlsViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    // MARK: Initializers

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
