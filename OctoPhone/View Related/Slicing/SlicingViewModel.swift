//
//  SlicingViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Slicing view model inputs
protocol SlicingViewModelInputs {

}

/// Slicing view model outputs for view controller
protocol SlicingViewModelOutputs {

}

/// Common interface for slicing view model
protocol SlicingViewModelType {
    /// Available inputs
    var inputs: SlicingViewModelInputs { get }

    /// Available outputs
    var outputs: SlicingViewModelOutputs { get }
}

/// Slicing view controller logic
final class SlicingViewModel: SlicingViewModelType, SlicingViewModelInputs,
SlicingViewModelOutputs {
    var inputs: SlicingViewModelInputs { return self }

    var outputs: SlicingViewModelOutputs { return self }
}
