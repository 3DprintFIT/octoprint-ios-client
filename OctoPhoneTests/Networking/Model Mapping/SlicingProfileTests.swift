//
//  SlicingProfileTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class SlicingProfileTests: QuickSpec {
    override func spec() {
        describe("convert") {
            let key = "medium_quality"
            let displayName = "Medium Quality"
            let description = "This is a medium quiality profile"
            let isDefault = true

            context("JSON is valid") {
                var data: [String: Any]!

                beforeEach {
                    data = ["key": key, "description": description, "displayName": displayName, "default": isDefault]
                }

                afterEach {
                    data = nil
                }

                it("converts from JSON") {
                    expect(expression: { try SlicingProfile.fromJSON(json: data) }).toNot(throwError())
                    if let subject = try? SlicingProfile.fromJSON(json: data) {
                        expect(subject.ID) == key
                        expect(subject.name) == displayName
                        expect(subject.profileDescription) == description
                        expect(subject.isDefault) == isDefault
                    }
                }

                it("allows empty name") {
                    data.removeValue(forKey: "displayName")

                    expect(expression: { try SlicingProfile.fromJSON(json: data) }).toNot(throwError())
                    if let subject = try? SlicingProfile.fromJSON(json: data) {
                        expect(subject.name).to(beNil())
                    }
                }

                it("does not require default propery") {
                    data.removeValue(forKey: "default")

                    expect(expression: { try SlicingProfile.fromJSON(json: data) }).toNot(throwError())
                    if let subject = try? SlicingProfile.fromJSON(json: data) {
                        expect(subject.isDefault) == false
                    }
                }
            }

            context("invalid JSON") {
                let data: [String: Any] = [:]

                it("throws an error") {
                    expect(expression: { try SlicingProfile.fromJSON(json: data) }).to(throwError())
                }
            }
        }
    }
}
