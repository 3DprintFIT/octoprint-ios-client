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

// Adds producer property to Realm Results collection
extension Results {
    /// Data change signal producer
    var producer: SignalProducer<(), NoError> {
        return SignalProducer({ observer, disposable in
            let token = self.addNotificationBlock({ _ in
                observer.send(value: ())
            })

            disposable.add {
                token.stop()
            }
        })
    }
}
