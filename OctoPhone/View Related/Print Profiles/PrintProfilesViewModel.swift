//
//  PrintProfilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Print profiles view model outputs
protocol PrintProfilesViewModelInputs {

}

/// Print profiles view model inputs
protocol PrintProfilesViewModelOutputs {

}

/// Common interface for print profiles view model
protocol PrintProfilesViewModelType {
    /// Available inputs
    var inputs: PrintProfilesViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfilesViewModelOutputs { get }
}

/// Print profiles view controller logic
final class PrintProfilesViewModel: PrintProfilesViewModelType, PrintProfilesViewModelInputs,
PrintProfilesViewModelOutputs {
    var inputs: PrintProfilesViewModelInputs { return self }

    var outputs: PrintProfilesViewModelOutputs { return self }
}
