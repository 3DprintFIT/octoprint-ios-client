//
//  SignalProducer+JSONAbleTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
import ReactiveSwift
import Moya
import ReactiveMoya
@testable import OctoPhone

class SignalProducerJSONAbleTests: QuickSpec {
    override func spec() {

        var emittedValue: GCodeAnalysis?
        var emittedCollection: [GCodeAnalysis]?
        var emittedError: MoyaError?

        beforeEach {
            emittedError = nil
            emittedValue = nil
            emittedCollection = nil
        }

        it("converts from valid json") {
            SignalProducer<Any, MoyaError>(value: self.createJSON())
                .mapTo(object: GCodeAnalysis.self).materialize().map{$0.event.value}.skipNil()
                .startWithValues{ emittedValue = $0 }

            expect(emittedValue).toNot(beNil())
        }

        it("converts from valid json at keypath") {
            SignalProducer<Any, MoyaError>(value: self.createJSON(keyPath: "key"))
                .mapTo(object: GCodeAnalysis.self, forKeyPath: "key").materialize().map{ $0.event.value }.skipNil()
                .startWithValues{ emittedValue = $0 }

            expect(emittedValue).toNot(beNil())
        }

        it("converts from valid json collection") {
            SignalProducer<Any, MoyaError>(value: self.createCollection())
                .mapTo(collectionOf: GCodeAnalysis.self).materialize().map{$0.event.value}.skipNil()
                .startWithValues{ emittedCollection = $0 }

            expect(emittedCollection).toNot(beNil())
        }

        it("converts from valid json collection at keypath") {
            SignalProducer<Any, MoyaError>(value: self.createCollection(keyPath: "key"))
                .mapTo(collectionOf: GCodeAnalysis.self, forKeyPath: "key").materialize().map{$0.event.value}.skipNil()
                .startWithValues{ emittedCollection = $0 }

            expect(emittedCollection).toNot(beNil())
        }

        it("converts dictionary to collection") {
            let dictionary = ["cura": ["default": true, "displayName": "CuraEngine", "key": "cura"]]

            SignalProducer<Any, MoyaError>(value: dictionary)
                .mapDictionary(collectionOf: Slicer.self).materialize().map{ $0.value }.skipNil()
                .startWithValues { _ in emittedCollection = [] }

            expect(emittedCollection).toNot(beNil())
        }

        it("fails conversion with invalid json") {
            SignalProducer<Any, MoyaError>(value: 0)
                .mapTo(object: GCodeAnalysis.self)
                .startWithFailed{ emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion with invalid json mapping") {
            SignalProducer<Any, MoyaError>(value: ["key": 0])
                .mapTo(object: GCodeAnalysis.self)
                .startWithFailed { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion with invalid json at keypath") {
            SignalProducer<Any, MoyaError>(value: ["key": 0])
                .mapTo(object: GCodeAnalysis.self, forKeyPath: "key")
                .startWithFailed { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion from invalid json collection") {
            SignalProducer<Any, MoyaError>(value: 0)
                .mapTo(collectionOf: GCodeAnalysis.self)
                .startWithFailed { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion from invalid json collection mapping") {
            SignalProducer<Any, MoyaError>(value: ["key": []])
                .mapTo(collectionOf: GCodeAnalysis.self)
                .startWithFailed { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion from invalid json collection at keypath") {
            SignalProducer<Any, MoyaError>(value: ["key": 0])
                .mapTo(collectionOf: GCodeAnalysis.self, forKeyPath: "key")
                .startWithFailed { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion with invalid json") {
            SignalProducer<Any, MoyaError>(value: ["cura", "test"])
                .mapDictionary(collectionOf: Slicer.self).materialize().map{ $0.error }.skipNil()
                .startWithValues { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }

        it("fails conversion with ivalid object in json") {
            let dictionary = ["cura": ["default": true, "displayName": "CuraEngine"]]

            SignalProducer<Any, MoyaError>(value: dictionary)
                .mapDictionary(collectionOf: Slicer.self).materialize().map{ $0.error }.skipNil()
                .startWithValues { emittedError = $0 }

            expect(emittedError).toNot(beNil())
        }
    }

    /// Creates JSON object
    ///
    /// - Parameter keyPath: Wrapper keypath
    /// - Returns: Valid JSON object
    func createJSON(keyPath: String? = nil) -> Any {
        let json: [String: Any] = [
            "estimatedPrintTime": 124334,
            "filament": [
                "tool0": [
                    "length": 21387,
                    "volume": 49.69353811199803
                ]
            ]
        ]


        if let keyPath = keyPath {
            return [keyPath: json]
        }

        return json
    }

    /// Crates collection of JSONs
    ///
    /// - Parameter keyPath: Wrapper keyPath
    /// - Returns: Collection of valid JSONs
    func createCollection(keyPath: String? = nil) -> Any {
        var jsons = [Any]()

        for _ in 0...3 { jsons.append(createJSON()) }

        if let keyPath = keyPath {
            return [keyPath: jsons]
        }

        return jsons
    }
}
