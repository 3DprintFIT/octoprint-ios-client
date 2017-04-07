//
//  PrinterProfileTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class PrinterProfileTests: QuickSpec {
    override func spec() {
        describe("Printer profile") {
            describe("converts from JSON") {
                context("valid JSON") {
                    var data: [String: Any]!

                    beforeEach {
                        data = ["id": "_default", "model": "RepRap Printer", "name": "Default"]
                    }

                    afterEach {
                        data = nil
                    }

                    it("converts") {
                        expect() { try PrinterProfile.fromJSON(json: data) }.toNot(throwError())
                        if let subject = try? PrinterProfile.fromJSON(json: data) {
                            expect(subject.ID) == "_default"
                            expect(subject.name) == "Default"
                            expect(subject.model) == "RepRap Printer"
                        }
                    }
                }

                context("invalid JSON") {
                    var data: [String: Any]!

                    beforeEach {
                        data = [:]
                    }

                    afterEach {
                        data = nil
                    }
                    
                    it("throws an error") {
                        expect() { try PrinterProfile.fromJSON(json: data) }.to(throwError())
                    }
                }
            }

            describe("converts to JSON") {
                let profile = PrinterProfile(ID: "Identifier", model: "Model", name: "Name")

                it("creates valid JSON") {
                    let json = profile.asJSON()

                    expect((json["id"] as! String)) == "Identifier"
                    expect((json["name"] as! String)) == "Name"
                    expect((json["model"] as! String)) == "Model"
                }

                it("converts all required properties to json") {
                    expect(profile.asJSON().count) == 3
                }
            }
        }

    }
}
