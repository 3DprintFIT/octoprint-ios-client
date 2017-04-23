//
//  SDCard+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

extension SDCard: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> SDCard {
        guard let ready = json["ready"] as? Bool else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return SDCard(ready: ready)
    }
}
