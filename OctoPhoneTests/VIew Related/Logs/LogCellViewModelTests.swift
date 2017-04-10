//
//  LogCellViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import ReactiveSwift
@testable import OctoPhone

class LogCellViewModelTests: QuickSpec {
    override func spec() {
        let contextManager = InMemoryContextManager()

        var subject: LogCellViewModelType!
        var log: Log!

        beforeEach {
            let realm = try! contextManager.createContext()
            try! realm.write { realm.deleteAll() }

            log = Log(name: "Log", size: 1234, lastModified: 4567, remotePath: "/log.log", referencePath: "http://log.log")

            try! realm.write { realm.add(log) }

            subject = LogCellViewModel(log: log)
        }

        afterEach {
            subject = nil
            log = nil
        }

        it("displays initial log data correctly formatted") {
            var name = ""
            var size = ""

            subject.outputs.name.startWithValues { name = $0 }
            subject.outputs.size.startWithValues { size = $0 }

            expect(name).toEventually(equal("Log"))
            expect(size).toEventually(equal("1 KB"))
        }

        it("updates outputs when log data are changed") {
            var name = ""
            var size = ""

            let realm = try! contextManager.createContext()
            try! realm.write {
                log.name = "Updated Log"
                log.size = 4567
            }

            subject.outputs.name.startWithValues { name = $0 }
            subject.outputs.size.startWithValues { size = $0 }

            expect(name).toEventually(equal("Updated Log"))
            expect(size).toEventually(equal("4 KB"))
        }
    }
}
