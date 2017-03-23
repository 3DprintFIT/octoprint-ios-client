//
//  Realm+ReactiveSwift.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

/// Describes type of change which happend on collection
///
/// - initial: Collection vas initialized
/// - update: Collection content changed
enum RealmCollectionChange<T> {
    case initial(T)
    case update(value: T, deletions: [Int], insertions: [Int], modifications: [Int])
}

/// Common Realm collection change error
///
/// - underlyingError: Wrapper for realm error
enum RealmError: Error {
    case underlyingError(_: Error)
}

// MARK: - Reactive extensions for RealmCollection
extension Reactive where Base: RealmCollection {
    /// Collection changes producer
    var changes: SignalProducer<RealmCollectionChange<Base>, RealmError> {
        var notificationToken: NotificationToken?

        return SignalProducer({ observer, _ in

            notificationToken = self.base.addNotificationBlock({ change in
                switch change {
                case let .initial(value):
                    observer.send(value: .initial(value))
                case let .update(value, deletions, insertions, modifications):
                    observer.send(value: .update(value: value,
                                                 deletions: deletions,
                                                 insertions: insertions,
                                                 modifications: modifications))
                case let .error(error):
                    observer.send(error: .underlyingError(error))
                }
            })
        })
        .on(interrupted: {
            notificationToken?.stop()
            notificationToken = nil
        })
        .on(terminated: {
            notificationToken?.stop()
            notificationToken = nil
        })
    }

    /// Produce new value whenever realm collection is changed,
    /// also notifies on intial change
    var values: SignalProducer<Base, RealmError> {
        return changes.map({ change in
            switch change {
            case let .initial(value): return value
            case let .update(value, _, _, _): return value
            }
        })
    }
}

// MARK: - Reactive extensions for Object
extension Reactive where Base: Object {
    /// Produces new value every time the object was changed
    var values: SignalProducer<Base, RealmError> {
        var notificationToken: NotificationToken?

        return SignalProducer.init({ observer, _ in

            // Initial value
            observer.send(value: self.base)

            notificationToken = self.base.addNotificationBlock({ change in
                switch change {
                case .change: observer.send(value: self.base)
                case let .error(error): observer.send(error: .underlyingError(error))
                case .deleted: observer.sendCompleted()
                }
            })
        })
        .on(interrupted: {
            notificationToken?.stop()
            notificationToken = nil
        })
        .on(terminated: {
            notificationToken?.stop()
            notificationToken = nil
        })
    }
}

// MARK: - Reactive extensions for collection fetch
extension SignalProducerProtocol where Value == Realm, Error == RealmError {
    func fetch<Subject: Object>(collectionOf type: Subject.Type)
        -> SignalProducer<Results<Subject>, RealmError> {

            return flatMap(.latest) { $0.objects(type).reactive.values }
    }
}
