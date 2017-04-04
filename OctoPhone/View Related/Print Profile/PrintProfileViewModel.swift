//
//  PrintProfileViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Print profile detail inputs
protocol PrintProfileViewModelInputs {

}

// MARK: - Outputs

/// Print profile logic output
protocol PrintProfileViewModelOutputs {
    /// Creates VIew Mo
    ///
    /// - Returns: <#return value description#>
    func printNameCellViewModel() -> PrintProfileTextInputCellViewModel

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func printIdentifierCellViewModel() -> PrintProfileTextInputCellViewModel

    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func printModelCellViewModel() -> PrintProfileTextInputCellViewModel
}

// MARK: - Common public interface

/// Common protocol for print profile logic
protocol PrintProfileViewModelType {
    /// Available inputs
    var inputs: PrintProfileViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfileViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Print profile detail logic
final class PrintProfileViewModel: PrintProfileViewModelType, PrintProfileViewModelInputs,
PrintProfileViewModelOutputs {
    var inputs: PrintProfileViewModelInputs { return self }

    var outputs: PrintProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    /// identifier of print profile
    private let printProfileID: String

    /// Printer request provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    // MARK: Initializers

    init(printProfileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.printProfileID = printProfileID
        self.provider = provider
        self.contextManager = contextManager
    }

    // MARK: Input methods

    // MARK: Output methods

    func printNameCellViewModel() -> PrintProfileTextInputCellViewModel {
        return PrintProfileTextInputCellViewModel(description: tr(.printProfileName))
    }

    func printIdentifierCellViewModel() -> PrintProfileTextInputCellViewModel {
        return PrintProfileTextInputCellViewModel(description: tr(.printProfileIdentifier))
    }

    func printModelCellViewModel() -> PrintProfileTextInputCellViewModel {
        return PrintProfileTextInputCellViewModel(description: tr(.printProfileModel))
    }

    // MARK: Internal logic
}
