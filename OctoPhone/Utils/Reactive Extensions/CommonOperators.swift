//
//  CommonOperators.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

/// Add skipError operator for producers which may produce error
extension SignalProducerProtocol where Error == Error {
    /// Add ability to skip errors produced by `self`
    ///
    /// - Returns: Producer, which sends empty producer on error
    func skipError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in return SignalProducer<Self.Value, NoError>.empty }
    }
}

extension SignalProducerProtocol {
    /// Map each value of `self` to Void
    ///
    /// - Returns: New producer, where original values are replaced by Void
    func ignoreValues() -> SignalProducer<(), Self.Error> {
        return map({ _ in })
    }
}

extension SignalProtocol {
    /// Map each value to Void
    ///
    /// - Returns: New signal, where original values are replaced by Void
    func ignoreValues() -> Signal<(), Self.Error> {
        return map({ _ in return })
    }
}
