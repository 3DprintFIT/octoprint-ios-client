//
//  FileTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import OctoPhone

class FileSpec: QuickSpec {
    override func setUp() {
        continueAfterFailure = false
    }

    override func spec() {
        it("converts from JSON") {
            let name = "whistle_v2.gcode"
            let type = "machinecode"
            let size = 1468987
            let date = 1378847754
            let origin = "local"
            let resource = "http://example.com/api/files/local/whistle_v2.gcode"
            let download = "http://example.com/downloads/files/local/whistle_v2.gcode"
            let estimatedPrintTime = 1188
            let filamentLength = 810
            let filamentVolume = 5.36
            let failures = 4
            let successes = 23
            let lastDate = 1387144346
            let lastSuccess = true

            let refs = ["download": download, "resource": resource]
            let analysis: [String : Any] = ["estimatedPrintTime": estimatedPrintTime, "filament": ["tool0": ["length": filamentLength, "volume": filamentVolume]]]
            let print: [String : Any] = ["failure": failures, "success": successes, "last": ["date": lastDate, "success": lastSuccess]]
            let data: [String: Any] = ["name": name, "type": type, "size": size, "date": date, "origin": origin, "resource": resource, "refs": refs, "gcodeAnalysis": analysis, "print": print]

            expect{ try File.fromJSON(json: data) }.toNot(throwError())
            if let file = try? File.fromJSON(json: data) {
                expect(file.name) == name
                expect(file.type.rawValue) == type
                expect(file.size) == size
                expect(file.date) == date
                expect(file.origin.rawValue) == origin
                expect(file.resource) == resource
                expect(file.download) == download
                expect(file.gcodeAnalysis) != nil
                expect(file.printStats) != nil
                expect(file.gcodeAnalysis!.estimatedPrintTime) == estimatedPrintTime
                expect(file.gcodeAnalysis!.filamentVolume) == filamentVolume
                expect(file.gcodeAnalysis!.filamentLength) == filamentLength
                expect(file.printStats!.failures) == failures
                expect(file.printStats!.lastPrint) == lastDate
                expect(file.printStats!.wasLastPrintSuccess) == lastSuccess
            }
        }

        it("throws error on invalid JSON") { 
            expect{ try File.fromJSON(json: [:]) }.to(throwError())
        }
    }
}
