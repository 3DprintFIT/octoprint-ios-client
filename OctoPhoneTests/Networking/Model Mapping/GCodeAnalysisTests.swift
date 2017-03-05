//
//  GCodeAnalysisTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class GCodeAnalysisSpec: QuickSpec {
    override func spec() {
        it("converts from JSON") {
            let estimatedPrintTime = 1188
            let filamentLength = 810
            let filamentVolume = 5.36
            let data: [String : Any] = ["estimatedPrintTime": estimatedPrintTime, "filament": [ "tool0": ["length": filamentLength, "volume": filamentVolume]]]

            expect{ try GCodeAnalysis.fromJSON(json: data) }.toNot(throwError())
            if let analysis = try? GCodeAnalysis.fromJSON(json: data) {
                expect(analysis).toNot(beNil())
                expect(analysis.estimatedPrintTime) == estimatedPrintTime
                expect(analysis.filamentVolume) == filamentVolume
                expect(analysis.filamentLength) == filamentLength
            }
        }

        it("throws on invalid JSON") { 
            expect{ try GCodeAnalysis.fromJSON(json: [:]) }.to(throwError())
        }
    }
}
