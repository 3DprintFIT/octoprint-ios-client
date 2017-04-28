//
//  CommandCellViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import Moya
import ReactiveMoya
@testable import OctoPhone

class CommandCellViewModelTests: QuickSpec {
    override func spec() {
        let provider = OctoPrintProvider(baseURL: URL(string: "localhost")!, stubClosure: MoyaProvider.immediatelyStub)
        var testedCommand: Command!

        var subject: CommandCellViewModel!
        var contextManager: InMemoryContextManager!
        var outputText = ""

        beforeEach {
            testedCommand = Command(value: "M105", status: .processing)
            contextManager = InMemoryContextManager()

            let realm = try! contextManager.createContext()
            try! realm.write { realm.add(testedCommand) }

            subject = CommandCellViewModel(provider: provider, contextManager: contextManager, command: testedCommand)
        }

        afterEach {
            subject = nil
            contextManager = nil
        }

        it("outputs command value when it's created") { 
            subject.outputs.commandValue.producer.startWithValues({ outputText = $0 })
            expect(outputText) == testedCommand.value
        }
    }
}
