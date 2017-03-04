//
//  GCodeAnalysis+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension GCodeAnalysis: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> GCodeAnalysis {
        guard
            let estimatedTime = json["estimatedPrintTime"] as? Int,
            let filamentJSON = json["filament"] as? [String: Any],
            let length = filamentJSON["length"] as? Int,
            let volume = filamentJSON["volume"] as? Double else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return GCodeAnalysis(estimatedPrintTime: estimatedTime, filamentLength: length,
                             filamentVolume: volume)
    }
}
