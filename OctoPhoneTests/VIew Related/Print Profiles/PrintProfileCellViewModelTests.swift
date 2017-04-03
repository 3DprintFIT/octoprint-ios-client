//
//  PrintProfileCellViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class PrintProfileCellViewModelTests: QuickSpec {
    override func spec() {
        describe("Print profile View Model") {
            let contextManager = InMemoryContextManager()
            let printProfileID = "Profile1"

            var subject: PrintProfileCellViewModelType!
            var name = ""

            afterEach {
                let realm = try! contextManager.createContext()
                try! realm.write{ realm.deleteAll() }

                subject = nil
                name = ""
            }

            context("database is empty") {
                beforeEach {
                    subject = PrintProfileCellViewModel(printProfileID: printProfileID, contextManager: contextManager)
                }

                it("it displays placeholder for name") {
                    let disposable = subject.outputs.name.startWithValues({ name = $0 })

                    expect(name).toEventually(equal("Unknown printer profile"))

                    disposable.dispose()
                }
            }

            context("database is not empty") {

                beforeEach {
                    let realm = try! contextManager.createContext()
                    try! realm.write { realm.add(PrinterProfile(ID: printProfileID, model: "Model1", name: "My Profile")) }

                    subject = PrintProfileCellViewModel(printProfileID: printProfileID, contextManager: contextManager)
                }

                it("provides correct profile name") {
                    let disposable = subject.outputs.name.startWithValues({ name = $0 })

                    expect(name).toEventually(equal("My Profile"))

                    disposable.dispose()
                }

                it("updates name when model object is updated") {
                    let disposable = subject.outputs.name.startWithValues({ name = $0 })
                    let realm = try! contextManager.createContext()
                    let profile = realm.object(ofType: PrinterProfile.self, forPrimaryKey: printProfileID)

                    try! realm.write{ profile?.name = "My New Profile" }

                    expect(name).toEventually(equal("My New Profile"))

                    disposable.dispose()
                }
            }
        }
    }
}
