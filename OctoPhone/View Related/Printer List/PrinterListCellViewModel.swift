//
//  PrinterListCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// View model for printer list cell
protocol PrinterListCellViewModelType {
    /// Name of stored printer
    var printerName: String { get }

    /// URL of printer
    var printerURL: String { get }
}

/// View model for printer list cell
final class PrinterListCellViewModel: PrinterListCellViewModelType {

    var printerName: String

    var printerURL: String

    init(printer: Printer) {
        self.printerName = printer.name
        self.printerURL = printer.url.absoluteString
    }
}
