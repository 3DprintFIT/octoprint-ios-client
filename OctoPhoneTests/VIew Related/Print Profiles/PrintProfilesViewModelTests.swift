//
//  PrintProfilesViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import Moya
@testable import OctoPhone

class PrintProfilesViewModelTests: QuickSpec {
    override func spec() {
        describe("Print profiles View Model") {
            let provider = OctoPrintProvider(baseURL: URL(string: "http://localhost")!, stubClosure: MoyaProvider.immediatelyStub)
            let contextManager = InMemoryContextManager()

            var subject: PrintProfilesViewModelType!
            var changesCount = 0

            beforeEach {
                subject = PrintProfilesViewModel(delegate: self, provider: provider, contextManager: contextManager)
            }

            afterEach {
                subject = nil
                changesCount = 0

                let realm = try! contextManager.createContext()
                try! realm.write { realm.deleteAll() }
            }

            context("database is empty") {
                it("provides correct count of items") {
                    let disposable = subject.outputs.profilesChanged.startWithValues{ changesCount += 1 }

                    expect(subject.outputs.profilesCount.value) == 0
                    expect(changesCount).toEventually(equal(1))

                    disposable.dispose()
                }
            }

            context("database is not empty") {
                beforeEach {
                    let realm = try! contextManager.createContext()

                    try! realm.write {
                        realm.add(PrinterProfile(ID: "Profile1", model: "Model 1", name: "Name 1"), update: true)
                        realm.add(PrinterProfile(ID: "Profile2", model: "Model 2", name: "Name 2"), update: true)
                        realm.add(PrinterProfile(ID: "Profile3", model: "Model 3", name: "Name 3"), update: true)
                        realm.add(PrinterProfile(ID: "Profile4", model: "Model 4", name: "Name 4"), update: true)
                    }
                }

                it("provides correct count of items") {
                    let disposable = subject.outputs.profilesChanged.startWithValues{ _ in changesCount += 1 }

                    expect(subject.outputs.profilesCount.value).toEventually(equal(4))
                    expect(changesCount).toEventually(equal(2))

                    disposable.dispose()
                }

                it("notifies about update") {
                    let disposable = subject.outputs.profilesChanged.startWithValues{ changesCount += 1 }

                    let realm = try! contextManager.createContext()
                    try! realm.write {
                        realm.add(PrinterProfile(ID: "Profile5", model: "Model 5", name: "Name 5"), update: true)
                        realm.add(PrinterProfile(ID: "Profile6", model: "Model 6", name: "Name 6"), update: true)
                    }

                    expect(subject.outputs.profilesCount.value).toEventually(equal(6))
                    expect(changesCount).toEventually(equal(3))

                    disposable.dispose()
                }

                it("provides correct view model for cells") {
                    var names = ["", "", ""]

                    let disposable1 = subject.outputs.printProfileCellViewModel(for: 0).outputs.name.startWithValues{ names[0] = $0 }
                    let disposable2 = subject.outputs.printProfileCellViewModel(for: 1).outputs.name.startWithValues{ names[1] = $0 }
                    let disposable3 = subject.outputs.printProfileCellViewModel(for: 2).outputs.name.startWithValues{ names[2] = $0 }

                    expect(names[0]).toEventually(equal("Name 1"))
                    expect(names[1]).toEventually(equal("Name 2"))
                    expect(names[2]).toEventually(equal("Name 3"))

                    disposable1.dispose()
                    disposable2.dispose()
                    disposable3.dispose()
                }
            }
        }
    }
}

extension PrintProfilesViewModelTests: PrintProfilesViewControllerDelegate {
    func selectedPrinterProfile(_ printerProfile: PrinterProfile) {

    }

    func addButtonTappped() {

    }
}
