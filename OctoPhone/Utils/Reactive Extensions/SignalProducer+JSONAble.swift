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

extension SignalProducerProtocol where Value == Any, Error == MoyaError {
    /// Maps downloaded JSON to object
    ///
    /// - Parameter classType: Object type
    /// - Returns: New producer with mapped JSON
    func mapTo<T: JSONAble>(object classType: T.Type) -> SignalProducer<T, MoyaError> {
        return producer.flatMap(.latest) { json -> SignalProducer<T, MoyaError> in
            guard let dict = json as? [String: Any] else {
                return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
            }

            do {
                return SignalProducer(value: try T.fromJSON(json: dict))
            } catch {
                return SignalProducer(
                    error: .underlying(JSONAbleError.errorMappingJSONToObject(json: dict))
                )
            }
        }
    }

    /// Maps downloaded JSON to object
    ///
    /// - Parameter classType: Object type
    /// - Returns: New producer with mapped JSON
    func mapTo<T: JSONAble>(collectionOf classType: T.Type) -> SignalProducer<[T], MoyaError> {
        return producer.flatMap(.latest) { json -> SignalProducer<[T], MoyaError> in
            guard let dict = json as? [[String: Any]] else {
                return SignalProducer(error: .underlying(JSONAbleError.invalidJSON(json: json)))
            }

            var objects = [T]()

            // To track which object failed to map, we have to iterater over each of them
            for singleDict in dict {
                do {
                    objects.append(try T.fromJSON(json: singleDict))
                } catch {
                    return SignalProducer(
                        error: .underlying(JSONAbleError.errorMappingJSONToObject(json: singleDict))
                    )
                }
            }

            return SignalProducer(value: objects)
        }
    }
}
