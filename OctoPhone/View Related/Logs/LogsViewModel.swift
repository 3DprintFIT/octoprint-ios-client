//
//  LogsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Logs inputs
protocol LogsViewModelInputs {

}

/// Logs outputs
protocol LogsViewModelOutputs {

}

/// Common interface for logs view model
protocol LogsViewModelType {
    /// Available logs inputs
    var inputs: LogsViewModelInputs { get }

    /// Available logs outputs
    var outputs: LogsViewModelOutputs { get }
}

/// Logs controller logic
final class LogsViewModel: LogsViewModelType, LogsViewModelInputs, LogsViewModelOutputs {
    var inputs: LogsViewModelInputs { return self }

    var outputs: LogsViewModelOutputs { return self }
}
