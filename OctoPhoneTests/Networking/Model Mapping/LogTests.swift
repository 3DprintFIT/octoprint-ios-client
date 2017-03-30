//
//  LogTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class LogTests: QuickSpec {
    override func spec() {
        let lastModified = 1393158814
        let name = "serial.log"
        let size = 1798419
        let remotePath = "serial.log"
        let referencePath = "http://example.com/api/logs/serial.log"
        let localPath = "/var/logs/11-01-16.log"

        it("converts from JSON") {
            let refs: [String: Any] = ["resource": referencePath, "download": remotePath]
            let data: [String: Any] = ["date": lastModified, "name": name, "size": size, "refs": refs]

            expect{ try Log.fromJSON(json: data) }.notTo(throwError())
            if let log = try? Log.fromJSON(json: data) {
                expect(log).toNot(beNil())
                expect(log.lastModified) == lastModified
                expect(log.name) == name
                expect(log.size) == size
                expect(log.remotePath) == remotePath
                expect(referencePath) == referencePath
            }
        }

        it("marks the file as not dowloaded if local path is empty") {
            let log = Log(name: name, size: size, lastModified: lastModified, remotePath: remotePath, referencePath: referencePath)
            expect(log.isDownloaded) == false
        }

        it("marks the file as downloaded if local path is filled in") {
            let log = Log(name: name, size: size, lastModified: lastModified,
                          remotePath: remotePath, referencePath: referencePath, localPath: localPath)
            expect(log.isDownloaded) == true
        }

        it("should throw when json is not valid") {
            expect{ try Log.fromJSON(json: [:]) }.to(throwError())
        }
    }
}
