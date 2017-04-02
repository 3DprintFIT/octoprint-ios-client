//
//  SlicingProfileCellTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class SlicingProfileCellTests: QuickSpec {
    override func spec() {
        describe("Slicing profile cell") {
            let contextManger = InMemoryContextManager()

            var subject: SlicingProfileCellViewModelType!

            afterEach {
                subject = nil

                let realm = try! contextManger.createContext()

                try! realm.write{ realm.deleteAll() }
            }

            context("slicer profile not found") {
                beforeEach {
                    subject = SlicingProfileCellViewModel(profileID: "", contextManager: contextManger)
                }

                it("provides placeholder text for name") {
                    expect(subject.outputs.name.value) == "Unknown slicing profile"
                }
            }

            context("slicer profile is in database") {
                let profileID = "Profile"
                var profile: SlicingProfile!

                beforeEach {
                    profile = SlicingProfile(ID: profileID, name: nil, isDefault: true)
                    let realm = try! contextManger.createContext()

                    try! realm.write{ realm.add(profile) }

                    subject = SlicingProfileCellViewModel(profileID: profileID, contextManager: contextManger)
                }

                afterEach {
                    profile = nil
                }

                it("provides placeholder name if profile name is empty") {
                    expect(subject.outputs.name.value) == "Unknown slicing profile"
                }

                it("displays profile name if it's not empty") {
                    let realm = try! contextManger.createContext()

                    try! realm.write { profile.name = "Slicer name" }
                    expect(subject.outputs.name.value).toEventually(equal("Slicer name"))
                }

                it("reacts to profile changes") {
                    let realm = try! contextManger.createContext()

                    try! realm.write { profile.name = "Change 1" }
                    expect(subject.outputs.name.value).toEventually(equal("Change 1"))

                    try! realm.write { profile.name = "Change 2" }
                    expect(subject.outputs.name.value).toEventually(equal("Change 2"))

                    try! realm.write { profile.name = "Change 3" }
                    expect(subject.outputs.name.value).toEventually(equal("Change 3"))
                }
            }
        }
    }
}
