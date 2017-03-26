//
//  PrinterListViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import ReactiveSwift
import RealmSwift
@testable import OctoPhone

class PrinterListViewModelTests: QuickSpec {

    var onSelectedPrinterProvider: ((OctoPrintProvider) -> Void)?
    var onAddPrinterButtonTapped: (() -> Void)?

    override func spec() {
        var contextManager: InMemoryContextManager!
        var subject: PrinterListViewModel!
        var selectedProvider: OctoPrintProvider!
        var printersCountChanged = 0
        var addPrinterTapped = false

        beforeEach {
            self.onAddPrinterButtonTapped = { addPrinterTapped = true }
            self.onSelectedPrinterProvider = { selectedProvider = $0 }

            contextManager = InMemoryContextManager()
            subject = PrinterListViewModel(delegate: self, contextManager: contextManager)
            subject.outputs.storedPrintersChanged.startWithValues { printersCountChanged += 1 }
        }

        afterEach {
            // Force context to flush database
            let realm = try! contextManager.createContext()
            try! realm.write { realm.deleteAll() }

            subject = nil
            contextManager = nil
            selectedProvider = nil
            printersCountChanged = 0
            addPrinterTapped = false
        }

        it("notify delegate only when add button is tapped") {
            expect(addPrinterTapped) == false
            subject.inputs.addPrinterButtonTapped()
            expect(addPrinterTapped) == true
        }

        it("update printers count dataset changed") {
            expect(printersCountChanged) == 1
            expect(subject.storedPrintersCount) == 0

            let realm = try! contextManager.createContext()
            try! realm.write {
                realm.add(self.createPrinter(index: 0))
            }

            expect(printersCountChanged) == 2
            expect(subject.outputs.storedPrintersCount) == 1

            try! realm.write {
                realm.add(self.createPrinter(index: 1))
            }

            expect(printersCountChanged) == 3
            expect(subject.outputs.storedPrintersCount) == 2
        }

        it("supply correct network provider when printer is selected") {
            expect(subject.outputs.storedPrintersCount) == 0
            expect(selectedProvider).to(beNil())

            let realm = try! contextManager.createContext()
            try! realm.write {
                realm.add(self.createPrinter(index: 0))
            }

            subject.inputs.selectedStoredPrinter(at: IndexPath.init(row: 0, section: 0))
            expect(selectedProvider).toNot(beNil())
        }

        it("provides correct view model for cell") {
            let realm = try! contextManager.createContext()
            try! realm.write {
                realm.add(self.createPrinter(index: 0))
                realm.add(self.createPrinter(index: 1))
            }

            let model0 = subject.outputs.storedPrinterCellViewModel(for: 0)
            expect(model0.printerName) == "My Printer 0"
            expect(model0.printerURL) == "http://localhost0"

            let model1 = subject.outputs.storedPrinterCellViewModel(for: 1)
            expect(model1.printerName) == "My Printer 1"
            expect(model1.printerURL) == "http://localhost1"
        }
    }

    /// Create new printer object
    ///
    /// - Parameter index: Object identifier in collection
    /// - Returns: New Printer with given index identifier
    func createPrinter(index: Int) -> Printer {
        return Printer(url: URL(string: "http://localhost\(index)")!, accessToken: "Secret Token \(index)", name: "My Printer \(index)")
    }
}

extension PrinterListViewModelTests: PrinterListViewControllerDelegate {
    func selectedPrinterProvider(provider: OctoPrintProvider) {
        onSelectedPrinterProvider?(provider)
    }

    func addPrinterButtonTapped() {
        onAddPrinterButtonTapped?()
    }
}
