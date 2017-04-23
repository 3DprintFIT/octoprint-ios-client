//
//  SDCardManagementViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs
/// SD card management inputs
protocol SDCardManagementViewModelInputs {

}

// MARK: - Outputs
/// SD card management outputs
protocol SDCardManagementViewModelOutputs {

}

// MARK: - Common public interface
/// Common interface for SD card managing view models
protocol SDCardManagementViewModelType {
    /// Available inputs
    var inputs: SDCardManagementViewModelInputs { get }

    /// Available outputs
    var outputs: SDCardManagementViewModelOutputs { get }
}

// MARK: - View Model implementation
/// SD Card management logic
final class SDCardManagementViewModel: SDCardManagementViewModelType, SDCardManagementViewModelInputs,
SDCardManagementViewModelOutputs {
    var inputs: SDCardManagementViewModelInputs { return self }

    var outputs: SDCardManagementViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    // MARK: Initializers

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
