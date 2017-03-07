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
import RealmSwift
@testable import OctoPhone

class RealmReactiveSwiftTests: QuickSpec {
    override func spec() {
        var contextManager: InMemoryContextManager!
        var realm: Realm!
        var changesEmitted = 0

        beforeEach {
            contextManager = InMemoryContextManager()
            realm = try! contextManager.createContext()
        }

        afterEach {
            changesEmitted = 0
        }

        it("emits when object is added to cellection") {
            let disp = realm.objects(FilePrintStats.self).producer.startWithValues {
                changesEmitted += 1
            }

            expect(changesEmitted) == 0

            try! realm.write { realm.add(self.createStat()) }

            expect(changesEmitted) == 1
            disp.dispose()
        }

        it("emits when object is deleted from collection") {
            let stat = self.createStat()
            try! realm.write { realm.add(stat) }

            let disp = realm.objects(FilePrintStats.self).producer.startWithValues {
                changesEmitted += 1
            }

            expect(changesEmitted) == 0

            try! realm.write {
                realm.delete(stat)
            }

            expect(changesEmitted) == 1
            disp.dispose()
        }

        it("emits when object in collection is updated") { 
            let stat = self.createStat()
            try! realm.write { realm.add(stat) }

            let disp = realm.objects(FilePrintStats.self).producer.startWithValues {
                changesEmitted += 1
            }

            expect(changesEmitted) == 0

            try! realm.write {
                stat.successes = 1
            }

            expect(changesEmitted) == 1
            disp.dispose()
        }
    }

    func createStat() -> FilePrintStats {
        return FilePrintStats(failures: 0, successes: 0, lastPrint: 0, wasLastPrintSuccess: true)
    }
}
