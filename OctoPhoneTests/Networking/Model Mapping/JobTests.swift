//
//  JobTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 22/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class JobTests: QuickSpec {
    override func spec() {
        describe("Printing job") {
            describe("converts from JSON") {
                var data: [String: Any]!

                afterEach {
                    data = nil
                }

                context("valid JSON") {
                    beforeEach {
                        let printTime = 276, printTimeLeft = 912
                        data = [ "job" : [ "file": [ "name": "whistle_v2.gcode", "size": 1468987 ] ],
                                 "progress": [ "completion": 0.22334532, "printTime": printTime, "printTimeLeft": printTimeLeft ],
                                 "state": "Operational"
                        ]
                    }

                    it("converts") {
                        expect() { try Job.fromJSON(json: data) }.notTo(throwError())
                        if let job = try? Job.fromJSON(json: data) {
                            expect(job.fileName) == "whistle_v2.gcode"
                            expect(job.fileSize) == 1468987
                            expect(job.completion) == 0.22334532
                            expect(job.printTime) == 276
                            expect(job.printTimeLeft) == 912
                            expect(job.state) == "Operational"
                        }
                    }
                }

                context("invalid JSON") {
                    beforeEach {
                        data = [:]

                        expect() { try Job.fromJSON(json: data) }.to(throwError())
                    }
                }
            }
        }
    }
}
