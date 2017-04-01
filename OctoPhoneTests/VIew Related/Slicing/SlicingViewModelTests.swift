//
//  SlicingViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 29/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import Moya
@testable import OctoPhone

class SlicingViewModelTests: QuickSpec {
    override func spec() {
        let contextManager = InMemoryContextManager()
        let provider = OctoPrintProvider(baseURL: URL(string: "http://localhost")!, stubClosure: MoyaProvider.immediatelyStub)

        describe("Slicing View Model") { 
            var subject: SlicingViewModelType!
            var notificationsCount = 0

            beforeEach {
                subject = SlicingViewModel(provider: provider, contextManager: contextManager)
            }

            afterEach {
                let realm = try! contextManager.createContext()
                try! realm.write { realm.deleteAll() }
                subject = nil
            }

            describe("outputs") {
                it("notifies subscriber when slicers count changed") {
                    expect(notificationsCount) == 0

                    let realm = try! contextManager.createContext()
                    let disposable = subject.outputs.slicersChanged.startWithValues { notificationsCount += 1 }

                    expect(notificationsCount) == 1

                    try! realm.write { realm.add(Slicer(ID: "Slicer", name: "Slicer", isDefault: true)) }

                    expect(notificationsCount) == 2
                    expect(subject.outputs.slicersCount.value).toEventually(equal(1))

                    disposable.dispose()
                }

                context("database empty") {
                    it("provides no cell", closure: {
                        expect(subject.outputs.slicersCount.value) == 0
                    })
                }

                context("database not empty") {
                    beforeEach {
                        let realm = try! contextManager.createContext()
                        try! realm.write {
                            realm.add(self.createSlicer(index: 0))
                            realm.add(self.createSlicer(index: 1))
                            realm.add(self.createSlicer(index: 2))
                        }
                    }

                    it("provides correct count of items") {
                        expect(subject.outputs.slicersCount.value).toEventually(equal(3))
                    }

                    it("provides correct cell VMs") {
                        let cellVM1 = subject.outputs.slicingCellViewModel(for: 0)
                        expect(cellVM1.outputs.slicerName.value) == "Slicer 0"

                        let cellVM2 = subject.outputs.slicingCellViewModel(for: 1)
                        expect(cellVM2.outputs.slicerName.value) == "Slicer 1"

                        let cellVM3 = subject.outputs.slicingCellViewModel(for: 2)
                        expect(cellVM3.outputs.slicerName.value) == "Slicer 2"
                    }
                }
            }
        }
    }


    /// Helper for creating slicer objects
    ///
    /// - Parameter index: Unique sequence identifier for slicer
    /// - Returns: New unmanaged slicer object
    func createSlicer(index: Int) -> Slicer {
        return Slicer(ID: "Slicer \(index)", name: "Slicer \(index)", isDefault: true)
    }
}
