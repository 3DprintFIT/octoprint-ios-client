//
//  ContextManager.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Database connections manager
protocol ContextManagerType: class {
    /// Creates new connection to the database on specific thread
    ///
    /// - Returns: New database connection
    /// - Throws: RealmError
    func createContext() throws -> Realm
}

/// Preconfigured local database manager
final class ContextManager: ContextManagerType {
    public func createContext() throws -> Realm {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.deleteRealmIfMigrationNeeded = true

        return try Realm(configuration: configuration)
    }
}

/// In memory database manager - for test purposes
final class InMemoryContextManager: ContextManagerType {

    /// In memory realm identifier
    private let currentIdentifier: String

    init() {
        currentIdentifier = UUID().uuidString
    }

    public func createContext() throws -> Realm {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.inMemoryIdentifier = currentIdentifier

        return try Realm(configuration: configuration)
    }
}
