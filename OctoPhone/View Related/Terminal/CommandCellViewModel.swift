//
//  CommandCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

// MARK: - Inputs

/// Command cell logic inputs
protocol CommandCellViewModelInputs {

}

// MARK: - Outputs

/// Command cell logic outputs
protocol CommandCellViewModelOutputs {

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
final class CommandCellViewModel: CommandCellViewModelType, CommandCellViewModelInputs, CommandCellViewModelOutputs {
    var inputs: CommandCellViewModelInputs { return self }

    var outputs: CommandCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    /// Command send to the printer
    private let command: Command

    /// Printer connection provider
    private let provider: OctoPrintProvider

    // MARK: Initializers
    
    init(provider: OctoPrintProvider, command: Command) {
        self.provider = provider
        self.command = command
    }
    
    // MARK: Input methods
}
