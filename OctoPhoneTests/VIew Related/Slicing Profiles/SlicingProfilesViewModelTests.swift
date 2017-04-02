//
//  SlicingProfilesViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import Moya
@testable import OctoPhone

class SlicingProfilesViewModelTests: QuickSpec {
    override func spec() {
        describe("Slicing profiles view model") {
            let provider = OctoPrintProvider(baseURL: URL(string: "http://localhost")!, stubClosure: MoyaProvider.immediatelyStub)
            let slicerID = "SLC"
            let contextManager = InMemoryContextManager()

            var subject: SlicingProfilesViewModelType!
            var emittedErrors = 0
            var emittedChanges = 0

            afterEach {
                subject = nil
                emittedErrors = 0
                emittedChanges = 0
                let realm = try! contextManager.createContext()

                try! realm.write{ realm.deleteAll() }
            }

            context("database contains slicer with no profiles") {
                beforeEach {
                    // Load VM after the data are inserted
                    subject = SlicingProfilesViewModel(slicerID: slicerID, provider: provider, contextManager: contextManager)
                }

                it("provides zero count of profiles") {
                    expect(subject.outputs.profilesCount.value) == 0
                }

                it("does not emit error if slicer profiles are empty") {
                    expect(emittedErrors).toEventually(equal(0))
                }
            }

            context("database contains set of profiles") {

                beforeEach {
                    let realm = try! contextManager.createContext()
                    let slicer = Slicer(ID: slicerID, name: "", isDefault: true)

                    try! realm.write {
                        realm.add(slicer)
                        slicer.slicingProfiles.append(SlicingProfile(ID: "1", name: "Profile 1", isDefault: true))
                        slicer.slicingProfiles.append(SlicingProfile(ID: "2", name: "Profile 2", isDefault: true))
                        slicer.slicingProfiles.append(SlicingProfile(ID: "3", name: "Profile 3", isDefault: true))
                    }

                    subject = SlicingProfilesViewModel(slicerID: slicerID, provider: provider, contextManager: contextManager)
                }

                it("notifies about profiles update") {
                    let realm = try! contextManager.createContext()
                    let slicer = realm.object(ofType: Slicer.self, forPrimaryKey: slicerID)!
                    let disposable = subject.outputs.profilesChanged.producer.startWithValues { emittedChanges += 1 }

                    expect(emittedChanges).toEventually(equal(1))
                    expect(emittedChanges).toEventuallyNot(equal(2))

                    try! realm.write { slicer.slicingProfiles.append(SlicingProfile.init(ID: "7", name: nil, isDefault: true)) }
                    expect(emittedChanges).toEventually(equal(2))

                    disposable.dispose()
                }

                it("shows correct profiles count after grouped update") {
                    expect(subject.outputs.profilesCount.value).toEventually(equal(3))
                }

                it("shows correct count of profiles when data are changed") {
                    let realm = try! contextManager.createContext()
                    let slicer = realm.object(ofType: Slicer.self, forPrimaryKey: slicerID)!

                    try! realm.write { slicer.slicingProfiles.append(SlicingProfile(ID: "4", name: "Profile 4", isDefault: true)) }
                    expect(subject.outputs.profilesCount.value).toEventually(equal(4))

                    try! realm.write { slicer.slicingProfiles.append(SlicingProfile(ID: "5", name: "Profile 5", isDefault: true)) }
                    expect(subject.outputs.profilesCount.value).toEventually(equal(5))

                    try! realm.write { slicer.slicingProfiles.append(SlicingProfile(ID: "6", name: "Profile 6", isDefault: true)) }
                    expect(subject.outputs.profilesCount.value).toEventually(equal(6))
                }

                it("provides correct cell view model") {
                    expect(subject.outputs.slicingProfileCellViewModel(for: 0).outputs.name.value).toEventually(equal("Profile 1"))
                    expect(subject.outputs.slicingProfileCellViewModel(for: 1).outputs.name.value).toEventually(equal("Profile 2"))
                    expect(subject.outputs.slicingProfileCellViewModel(for: 2).outputs.name.value).toEventually(equal("Profile 3"))
                }
            }
        }
    }
}
