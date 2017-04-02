//
//  PrintProfilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

protocol PrintProfilesViewModelInputs {

}

// MARK: - Outputs

protocol PrintProfilesViewModelOutputs {

}

// MARK: - Common public interface

protocol PrintProfilesViewModelType {
    /// Available inputs
    var inputs: PrintProfilesViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfilesViewModelOutputs { get }
}

// MARK: - View Model implementation

final class PrintProfilesViewModel: PrintProfilesViewModelType, PrintProfilesViewModelInputs, PrintProfilesViewModelOutputs {
    var inputs: PrintProfilesViewModelInputs { return self }

    var outputs: PrintProfilesViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    // MARK: Initializers

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
