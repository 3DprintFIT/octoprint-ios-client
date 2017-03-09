//
//  TerminalViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Terminal inputs
protocol TerminalViewModelInputs {

}

/// Terminal outputs
protocol TerminalViewModelOutputs {

}

/// Common interface for terminal view model
protocol TerminalViewModelType {
    /// Available terminal inputs
    var inputs: TerminalViewModelInputs { get }

    /// Available terminal outputs
    var outputs: TerminalViewModelOutputs { get }
}

/// Terminal controller logic
final class TerminalViewModel: TerminalViewModelType, TerminalViewModelInputs,
TerminalViewModelOutputs {

    var inputs: TerminalViewModelInputs { return self }

    var outputs: TerminalViewModelOutputs { return self }
}
