//
//  ContextManager.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 19/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift


class ContextManager {
    public func createContext() throws -> Realm {
        return try Realm()
    }
}
