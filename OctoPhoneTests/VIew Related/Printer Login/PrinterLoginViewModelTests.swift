//
//  PrinterLoginViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import Moya
import ReactiveSwift
import Result
@testable import OctoPhone

class PrinterLoginViewModelSpec: QuickSpec {

    var onCancelLogin: ((Void) -> ())?
    var onSuccessfullyLoggedIn: ((Void) -> ())?

    override func spec() {
        var subject: PrinterLoginViewModel!

        var buttonEnabled: Bool!
        var loginCanceled: Bool!

        beforeEach {
            buttonEnabled = nil
            loginCanceled = nil

            self.onCancelLogin = {
                loginCanceled = true
            }

            subject = PrinterLoginViewModel(delegate: self, contextManager: InMemoryContextManager())

            subject.inputs.viewDidLoad()
            subject.outputs.isFormValid.observeValues({ buttonEnabled = $0 })
            subject.inputs.viewWillAppear()
        }

        afterEach {
            subject = nil
        }

        it("should disable login button when screen will appear") {
            expect(buttonEnabled).notTo(beNil())
            expect(buttonEnabled) == false
        }

        it("should require all fields filled") { 
            subject.inputs.printerNameChanged("My Printer")
            expect(buttonEnabled) == false
            subject.inputs.printerUrlChanged("http://localhost")
            expect(buttonEnabled) == false
            subject.inputs.tokenChanged("Secret token")
            expect(buttonEnabled) == true
        }

        it("should notify delegate when user cancels login") {
            expect(loginCanceled).to(beNil())
            subject.inputs.cancelLoginPressed()
            expect(loginCanceled).toNot(beNil())
            expect(loginCanceled) == true
        }

        it("requires valid url string as priner address") { 
            subject.inputs.printerNameChanged("My Printer")
            subject.inputs.tokenChanged("Secret token")
            subject.inputs.printerUrlChanged("Invalid url")
            expect(buttonEnabled) == false
            subject.inputs.printerUrlChanged("http://localhost")
        }
    }
}

extension PrinterLoginViewModelSpec: PrinterLoginViewControllerDelegate {
    func didCancelLogin() {
        onCancelLogin?()
    }

    func successfullyLoggedIn() {
        onSuccessfullyLoggedIn?()
    }
}
