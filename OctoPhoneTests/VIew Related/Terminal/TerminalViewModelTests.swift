//
//  TerminalViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Nimble
import Quick
import ReactiveSwift
@testable import OctoPhone

class TerminalViewModelTests: QuickSpec {
    override func spec() {
        let provider = OctoPrintProvider(baseURL: URL(string: "localhost")!)

        var contextManager: InMemoryContextManager!
        var subject: TerminalViewModel!
        var buttonEnabled = true
        var commandsCount = 0

        beforeEach {
            contextManager = InMemoryContextManager()
            subject = TerminalViewModel(provider: provider, contextManager: contextManager)
            buttonEnabled = true
            commandsCount = 0
        }

        afterEach {
            // Force context deallocation and bindings dispose
            subject = nil
            contextManager = nil
        }

        it("disables send button by default") {
            subject.outputs.isCommandValid.startWithValues({ buttonEnabled = $0 })
            expect(buttonEnabled) == false
        }

        it("enables send button when command is valid") {
            buttonEnabled = false
            subject.inputs.commandChanged("M105")
            subject.outputs.isCommandValid.startWithValues({ buttonEnabled = $0 })
            expect(buttonEnabled) == true
        }

        it("shows correct commands count if database is empty") {
            expect(subject.outputs.commandsCount) == 0
        }

        it("notifies when commands count is changed") {
            subject.outputs.commandsChanged.startWithValues { commandsCount += 1 }
            let realm = try! contextManager.createContext()

            try! realm.write { realm.add(Command(value: "M105", status: .processing)) }

            expect(commandsCount) == 1
        }

        it("creates new command when send button is pressed") {
            subject.inputs.commandChanged("M106")
            subject.inputs.sendButtonPressed()

            expect(subject.outputs.commandsCount) == 1

            subject.inputs.commandChanged("M107")
            subject.inputs.sendButtonPressed()

            expect(subject.outputs.commandsCount) == 2
        }
    }
}
