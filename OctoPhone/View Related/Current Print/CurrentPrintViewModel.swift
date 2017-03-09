//
//  CurrentPrintViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

/// Common interface for printer view model inputs
protocol CurrentPrintViewModelInputs {

}

/// Common interface for pritner view model outputs
protocol CurrentPrintViewModelOutputs {

}

/// Common interface current print for view model
protocol CurrentPrintViewModelType {
    /// Inputs from view controller
    var inputs: CurrentPrintViewModelInputs { get }

    /// Outputs for view controller
    var outputs: CurrentPrintViewModelOutputs { get }
}

/// Takes inputs a generates outputs for current print view controller
final class CurrentPrintViewModel: CurrentPrintViewModelType, CurrentPrintViewModelInputs,
CurrentPrintViewModelOutputs {

    var inputs: CurrentPrintViewModelInputs { return self }

    var outputs: CurrentPrintViewModelOutputs { return self }
}
