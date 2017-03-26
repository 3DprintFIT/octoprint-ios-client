//
//  LogsViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import RealmSwift
import ReactiveSwift
@testable import OctoPhone

class LogsViewModelTests: QuickSpec {
    override func spec() {
        let provider = OctoPrintProvider(baseURL: URL(string: "http://localhost")!)
        let contextManager = InMemoryContextManager()

        var subject: LogsViewModelType!
        var currentCount = 0
        var disposable: Disposable!

        beforeEach {
            subject = LogsViewModel(provider: provider, contextManager: contextManager)
            currentCount = 0

            let realm = try! contextManager.createContext()
            try! realm.write{ realm.deleteAll() }
        }

        afterEach {
            subject = nil
            disposable?.dispose()
            disposable = nil
        }

        it("displays provides correct count of logs") {
            expect(subject.outputs.logsCount) == 0
            disposable = subject.outputs.logsListChanged.observeValues { currentCount = subject.outputs.logsCount }

            let first = self.createLog("first")
            let second = self.createLog("second")

            let realm = try! contextManager.createContext()
            try! realm.write {
                realm.add(first)
                realm.add(second)
            }

            expect(subject.outputs.logsCount) == 2
            expect(currentCount).toEventually(equal(2)) // evenutaly -> async
        }

        it("provides correct log model for index") {
            var firstName = ""
            var secondName = ""

            let first = self.createLog("first")
            let second = self.createLog("second")

            let realm = try! contextManager.createContext()
            try! realm.write {
                realm.add(first)
                realm.add(second)
            }

            let model = subject.outputs.logCellViewModel(for: 0)

            model.outputs.name.startWithValues{ firstName = $0 }
            model.outputs.size.startWithValues{ secondName = $0 }

            expect(firstName).toEventually(equal("first"))
            expect(secondName).toEventually(equal("1 234 bytes"))
        }
    }

    /// Creates new log with given key
    private func createLog(_ primaryKey: String) -> Log {
        return Log(name: "\(primaryKey)", size: 1234, lastModified: 5678,
                   remotePath: "RP\(primaryKey)", referencePath: "RF\(primaryKey)")
    }
}
