//
//  Realm+ReactiveSwiftTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import ReactiveSwift
import ReactiveCocoa
import RealmSwift
@testable import OctoPhone

class RealmReactiveSwiftTests: QuickSpec {
    override func spec() {
        let contextManager = InMemoryContextManager()

        var initialChanges = 0
        var collectionChanges = 0
        var emittedError: Error!
        var disposable: Disposable!

        context("collection changes property reacts to realm notifications and emits changes") {
            beforeEach {
                initialChanges = 0
                collectionChanges = 0
                emittedError = nil

                let realm = try! contextManager.createContext()

                disposable = realm.objects(FilePrintStats.self).reactive.changes.startWithResult { result in
                    switch result {
                    case let .success(change):
                        switch change {
                        case .initial: initialChanges += 1
                        case .update: collectionChanges += 1
                        }
                    case let .failure(error): emittedError = error
                    }
                }
            }

            afterEach {
                disposable.dispose()
                let realm = try! contextManager.createContext()
                try! realm.write { realm.deleteAll() }
            }

            it("emits initial change when collection is changed") {
                expect(initialChanges).toEventually(equal(1))
                expect(collectionChanges).toEventually(equal(0))
                expect(emittedError).toEventually(beNil())
            }

            it("emits changes for crud operations") {
                let stat = self.createStat()
                let realm = try! contextManager.createContext()

                try! realm.write { realm.add(stat) }

                expect(initialChanges).toEventually(equal(1))
                expect(collectionChanges).toEventually(equal(1))

                try! realm.write {
                    stat.wasLastPrintSuccess = true
                }

                expect(initialChanges).toEventually(equal(1))
                expect(collectionChanges).toEventually(equal(2))
                
                try! realm.write { realm.delete(stat) }
                
                expect(initialChanges).toEventually(equal(1))
                expect(collectionChanges).toEventually(equal(3))
                expect(emittedError).to(beNil())
            }

        }

        context("collection values property reacts to realm notifications and emits values") {
            beforeEach {
                initialChanges = 0
                collectionChanges = 0
                emittedError = nil

                let realm = try! contextManager.createContext()

                disposable = realm.objects(FilePrintStats.self).reactive.values.startWithResult { result in
                    switch result {
                    case .success: collectionChanges += 1
                    case let .failure(error): emittedError = error
                    }
                }
            }

            afterEach {
                disposable?.dispose()
                let realm = try! contextManager.createContext()
                try! realm.write { realm.deleteAll() }
            }

            it("emits value for initial change") {
                expect(collectionChanges).toEventually(equal(1))
                expect(emittedError).toEventually(beNil())
            }

            it("emits value for each crud operation") {
                let stat = self.createStat()
                let realm = try! contextManager.createContext()

                try! realm.write { realm.add(stat) }

                expect(collectionChanges).toEventually(equal(2))

                try! realm.write {
                    stat.wasLastPrintSuccess = true
                }

                expect(collectionChanges).toEventually(equal(3))

                try! realm.write { realm.delete(stat) }

                expect(collectionChanges).toEventually(equal(4))
                expect(emittedError).to(beNil())
            }
        }

        context("object values property reacts to realm notifications and emits values") {
            var stat: FilePrintStats!
            var completed = false

            beforeEach {
                initialChanges = 0
                collectionChanges = 0
                emittedError = nil
                stat = self.createStat()
                completed = false

                let realm = try! contextManager.createContext()
                try! realm.write { realm.add(stat) }

                disposable = stat.reactive.values
                    .on(completed: {
                        completed = true
                    })
                    .startWithResult({ result in
                    switch result {
                    case .success: collectionChanges += 1
                    case let .failure(error): emittedError = error
                    }
                })
            }

            it("emits initial value") {
                expect(collectionChanges).toEventually(equal(1))
            }

            it("emits for each crud operation") {
                let realm = try! contextManager.createContext()

                try! realm.write {
                    stat.successes += 1
                }

                expect(collectionChanges).toEventually(equal(2))

                try! realm.write {
                    stat.lastPrint = 10
                }

                expect(collectionChanges).toEventually(equal(3))
            }

            it("sends completed event when object is removed from realm") {
                expect(completed).toEventually(equal(false))

                let realm = try! contextManager.createContext()
                try! realm.write { realm.delete(stat) }

                expect(completed).toEventually(equal(true))
            }
        }
    }

    func createStat() -> FilePrintStats {
        return FilePrintStats(failures: 0, successes: 0, lastPrint: 0, wasLastPrintSuccess: true)
    }
}
