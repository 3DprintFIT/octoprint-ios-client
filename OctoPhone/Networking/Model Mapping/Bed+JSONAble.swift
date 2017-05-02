//
//  Bed+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension Bed: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> Bed {
        guard
            let actual = json["actual"] as? Double,
            let offset = json["offset"] as? Double,
            let target = json["target"] as? Double
        else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return Bed(actualTemperature: actual, targetTemperature: target, offsetTemperature: offset)
    }
}
