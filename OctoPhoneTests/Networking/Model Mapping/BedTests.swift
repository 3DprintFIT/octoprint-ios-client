//
//  BedTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class BedTests: QuickSpec {
    override func spec() {
        describe("Bed") {
            describe("converts from JSON") {
                var data: [String: Any]!

                afterEach {
                    data = nil
                }

                context("valid JSON") {
                    beforeEach {
                        data = ["actual": 10.2, "offset": 0.0, "target": 220.4]
                    }

                    it("converts") {
                        expect(expression: { try Bed.fromJSON(json: data) }).toNot(throwError())
                        if let subject = try? Bed.fromJSON(json: data) {
                            expect(subject.actualTemperature) == 10.2
                            expect(subject.offsetTemperature) == 0.0
                            expect(subject.targetTemperature) == 220.4
                        }
                    }
                }

                context("invalid JSON") {
                    beforeEach {
                        data = [:]
                    }

                    it("throws an error") {
                        expect(expression: { try Bed.fromJSON(json: data) }).to(throwError())
                    }
                }
            }
        }
    }
}
