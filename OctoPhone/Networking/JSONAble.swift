//
//  JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Indicates error during JSON serialization
///
/// - invalidJSON: Downloaded data are not convertible to JSON
/// - errorMappingJSONToObject: Downloaded data are valid but could not be mapped to object
enum JSONAbleError: Error {
    case invalidJSON(json: Any)
    case errorMappingJSONToObject(json: [String: Any])
}

/// Common interface for objects representable with JSON
protocol JSONAble {
    /// Creates new object from json
    ///
    /// - Parameter json: JSON data
    static func fromJSON(json: [String: Any]) throws -> Self
}
