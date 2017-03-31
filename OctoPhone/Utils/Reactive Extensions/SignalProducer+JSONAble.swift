//
//  SignalProducer+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift

// Allows to map JSON to Realm Object
extension SignalProducerProtocol where Value == Any, Error == MoyaError {
    /// Maps downloaded JSON to object
    ///
    /// - Parameters:
    ///   - classType: Object type
    ///   - keyPath: Search for object at specific keyPath
    /// - Returns: New producer with mapped JSON
    func mapTo<T: JSONAble>(object classType: T.Type,
                            forKeyPath keyPath: String? = nil) -> SignalProducer<T, MoyaError> {

        return producer.flatMap(.latest) { json -> SignalProducer<T, MoyaError> in
            guard let dict = json as? [String: Any] else {
                return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
            }

            var finalDict = dict

            if let keyPath = keyPath {
                guard let dict = dict[keyPath] as? [String: Value] else {
                    return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
                }

                finalDict = dict
            }

            do {
                return SignalProducer(value: try T.fromJSON(json: finalDict))
            } catch {
                return SignalProducer(
                    error: .underlying(error)
                )
            }
        }
    }

    /// Maps downloaded JSON to object
    ///
    /// - Parameter classType: Object type
    /// - Returns: New producer with mapped JSON
    func mapTo<T: JSONAble>(collectionOf classType: T.Type,
                            forKeyPath keyPath: String? = nil) -> SignalProducer<[T], MoyaError> {

        return producer.flatMap(.latest) { json -> SignalProducer<[T], MoyaError> in
            var finalDict = [[String: Any]]()

            if let keyPath = keyPath {
                guard
                    let dict = json as? [String: Any],
                    let subDict = dict[keyPath] as? [[String: Any]] else
                {
                    return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
                }

                finalDict = subDict
            } else {
                guard let dict = json as? [[String: Any]] else {
                    return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
                }

                finalDict = dict
            }

            var objects = [T]()

            // To track which object failed to map, we have to iterater over each of them
            for singleDict in finalDict {
                do {
                    objects.append(try T.fromJSON(json: singleDict))
                } catch {
                    return SignalProducer(
                        error: .underlying(error)
                    )
                }
            }

            return SignalProducer(value: objects)
        }
    }

    /// Maps JSON **object** to collection of objects. Decodes special JSON format,
    /// where collection is sent as object properties, not as array of objects.
    ///
    /// - Parameter classType: Class which is expected to be returned
    /// - Returns: Collection of objects of given type
    func mapDictionary<T: JSONAble>(collectionOf classType: T.Type) -> SignalProducer<[T], MoyaError> {
        return producer.flatMap(.latest) { json -> SignalProducer<[T], MoyaError> in
            guard let dict = json as? [String: [String: Any]] else {
                return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
            }

            var objects = [T]()

            for objectDict in dict {
                do {
                    objects.append(try T.fromJSON(json: objectDict.value))
                } catch {
                    return SignalProducer(error: .underlying(error))
                }
            }

            return SignalProducer(value: objects)
        }
    }
}
