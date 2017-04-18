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
            let filamentJSON = json["filament"] as? [String: [String: Double]],
            let length = filamentJSON.first?.1["length"],
            let volume = filamentJSON.first?.1["volume"] else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        let estimatedTime = json["estimatedPrintTime"] as? Int ?? 0

        return GCodeAnalysis(estimatedPrintTime: estimatedTime, filamentLength: length,
                             filamentVolume: volume)
    }
}
