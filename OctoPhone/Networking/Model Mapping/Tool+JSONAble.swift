//
//  Tool+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

// MARK: - JSONAble
extension Tool: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> Tool {
        guard
            let actual = json["actual"] as? Double,
            let offset = json["offset"] as? Double,
            let target = json["target"] as? Double
        else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return Tool(actual: actual, offset: offset, target: target)
    }
}
