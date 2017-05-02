//
//  PrinterStateTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class PrinterStateTests: QuickSpec {
    override func spec() {
        describe("Printer state") { 
            describe("converts from JSON") {
                var data: [String: Any]!

                afterEach {
                    data = nil
                }

                context("valid JSON") {
                    beforeEach {
                        data = ["state": ["flags": ["error": false], "text": "Operational"]]
                    }

                    it("converts") {
                        expect(expression: { try PrinterState.fromJSON(json: data) }).toNot(throwError())
                        if let subject = try? PrinterState.fromJSON(json: data) {
                            expect(subject.state) == "Operational"
                        }
                    }
                }

                context("invalid JSON") {
                    beforeEach {
                        data = [:]
                    }

                    it("throws an error") {
                        expect(expression: { try PrinterState.fromJSON(json: data) }).to(throwError())
                    }
                }
            }
        }
    }
}
