//
//  PrinterControlViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Inputs from view controller
protocol PrinterControlViewModelInputs {

}

/// Outputs for view controller
protocol PrinterControlViewModelOutputs {

}

/// Interface for printer control logic
protocol PrinterControlViewModelType {
    /// Exposed inputs API for view controller
    var inputs: PrinterControlViewModelInputs { get }

    /// Available outputs for view controller
    var outputs: PrinterControlViewModelOutputs { get }
}

/// Printer control controller logic
final class PrinterControlViewModel: PrinterControlViewModelType, PrinterControlViewModelInputs,
PrinterControlViewModelOutputs {

    var inputs: PrinterControlViewModelInputs { return self }

    var outputs: PrinterControlViewModelOutputs { return self }
}
