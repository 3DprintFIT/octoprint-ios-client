//
//  ContextManager.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

/// Database connections manager
protocol ContextManagerType: class {
    /// Creates new connection to the database on specific thread
    ///
    /// - Returns: New database connection
    /// - Throws: RealmError
    func createContext() throws -> Realm

    /// Creates signal with realm connection as value
    ///
    /// - Returns: Realm connection signal producer
    func createObservableContext() -> SignalProducer<Realm, RealmError>
}

/// Preconfigured local database manager
class ContextManager: ContextManagerType {

    /// Default configuration for app realm
    ///
    /// - Returns: New default configuration
    public func configuration() -> Realm.Configuration {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.deleteRealmIfMigrationNeeded = true

        return configuration
    }

    public func createContext() throws -> Realm {
        return try Realm(configuration: configuration())
    }

    public func createObservableContext() -> SignalProducer<Realm, RealmError> {
        return SignalProducer({ observer, _ in
            do {
                let realm = try Realm(configuration: self.configuration())

                observer.send(value: realm)
            } catch {
                observer.send(error: .underlyingError(error))
            }
        })
    }
}

/// In memory database manager - for test purposes
class InMemoryContextManager: ContextManager {

    /// In memory realm identifier
    private let currentIdentifier = UUID().uuidString

    override func configuration() -> Realm.Configuration {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.inMemoryIdentifier = currentIdentifier

        return configuration
    }
}
