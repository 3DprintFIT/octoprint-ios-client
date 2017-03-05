//
//  FilePrintStatsTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 05/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class FilePrintStatsSpec: QuickSpec {
    override func spec() {
        it("converts from JSON") {
            let failures = 4
            let successes = 23
            let lastDate = 1387144346
            let lastSuccess = true

            let last: [String: Any] = ["date": lastDate, "success": lastSuccess]
            let data: [String: Any] = ["failure": failures, "success": successes, "last": last]

            expect{ try FilePrintStats.fromJSON(json: data) }.notTo(throwError())
            if let stats = try? FilePrintStats.fromJSON(json: data) {
                expect(stats).toNot(beNil())
                expect(stats.failures) == failures
                expect(stats.successes) == successes
                expect(stats.lastPrint) == lastDate
                expect(stats.wasLastPrintSuccess) == lastSuccess
            }
        }

        it("should throw when json is not valid") {
            expect{ try FilePrintStats.fromJSON(json: [:]) }.to(throwError())
        }
    }
}
