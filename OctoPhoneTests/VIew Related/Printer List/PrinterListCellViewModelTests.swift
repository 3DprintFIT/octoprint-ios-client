//
//  PrinterListCellViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class PrinterListCellViewModelTests: QuickSpec {
    override func spec() {
        it("should map model correctly") {
            let printerPath = "http://localhost"
            let printerName = "My Printer"

            let printer = Printer(url: URL(string: printerPath)!, accessToken: "Secret Token", name: printerName, streamUrl: nil)
            let subject = PrinterListCellViewModel(printer: printer)

            expect(subject.printerName) == printerName
            expect(subject.printerURL) == printerPath
        }
    }
}
