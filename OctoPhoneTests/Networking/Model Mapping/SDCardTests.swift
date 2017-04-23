//
//  SDCardTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class SDCardTests: QuickSpec {
    override func spec() {
        describe("SDCard") {
            describe("converts from JSON") {
                var data: [String: Any]!

                context("valid JSON") {
                    beforeEach {
                        data = ["ready": false]
                    }

                    it("converts") {
                        expect() { try SDCard.fromJSON(json: data) }.notTo(throwError())
                        if let subject = try? SDCard.fromJSON(json: data) {
                            expect(subject.ready) == false
                        }
                    }
                }

                context("invalid JSON") {
                    beforeEach {
                        data = [:]
                    }

                    it("throws an error") {
                        expect() { try SDCard.fromJSON(json: data) }.to(throwError())
                    }
                }
            }
        }
    }
}
