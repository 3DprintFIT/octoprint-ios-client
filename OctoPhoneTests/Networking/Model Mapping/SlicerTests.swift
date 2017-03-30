//
//  SlicerTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class SlicerTests: QuickSpec {
    override func spec() {
        let key = "cura"
        let displayName = "Cura Engine"
        let isDefault = true

        describe("convert") { 
            context("JSON is valid") {
                var data: [String: Any]!

                beforeEach {
                    data = ["key": key, "displayName": displayName, "default": isDefault]
                }

                afterEach {
                    data = nil
                }

                it("converts from JSON") {
                    expect(expression: { try Slicer.fromJSON(json: data) }).notTo(throwError())
                    if let subject = try? Slicer.fromJSON(json: data) {
                        expect(subject.ID) == key
                        expect(subject.name) == displayName
                        expect(subject.isDefault) == isDefault
                    }
                }

                it("allows empty name") {
                    data.removeValue(forKey: "displayName")

                    expect(expression: { try Slicer.fromJSON(json: data) }).notTo(throwError())
                    if let subject = try? Slicer.fromJSON(json: data) {
                        expect(subject.name).to(beNil())
                    }
                }
            }

            context("invalid JSON") {
                let data: [String: Any] = [:]

                it("throws an error") {
                    expect(expression: { try Slicer.fromJSON(json: data) }).to(throwError())
                }
            }
        }
    }
}
