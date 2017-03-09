//
//  LogDetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Log detail inputs
protocol LogDetailViewModelInputs {

}

/// Log detail outputs
protocol LogDetailViewModelOutputs {

}

/// Common interface for log detail view model
protocol LogDetailViewModelType {
    /// Available inputs
    var inputs: LogDetailViewModelInputs { get }

    /// Available outputs
    var outputs: LogDetailViewModelOutputs { get }
}

final class LogDetailViewModel: LogDetailViewModelType, LogDetailViewModelInputs,
LogDetailViewModelOutputs {
    var inputs: LogDetailViewModelInputs { return self }

    var outputs: LogDetailViewModelOutputs { return self }
}
