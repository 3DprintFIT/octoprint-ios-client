//
//  ToolTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class ToolTests: QuickSpec {
    override func spec() {
        describe("Tool") {
            describe("converts from JSON") {
                var data: [String: Any]!

                afterEach {
                    data = nil
                }

                context("valid JSON") {
                    beforeEach {
                        data = ["target": 200.0, "offset": 5.0, "actual": 99.1]
                    }

                    it("converts") {
                        expect { try Tool.fromJSON(json: data) }.notTo(throwError())
                        if let subject = try? Tool.fromJSON(json: data) {
                            expect(subject.actualTemperature) == 99.1
                            expect(subject.offsetTemperature) == 5.0
                            expect(subject.targetTemperature) == 200.0
                        }
                    }
                }

                context("invalid JSON") {
                    beforeEach {
                        data = [:]
                    }

                    it("throws an error") {
                        expect { try Tool.fromJSON(json: data) }.to(throwError())
                    }
                }
            }
        }
    }
}
