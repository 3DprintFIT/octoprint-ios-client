//
//  PrinterProfile+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension PrinterProfile: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> PrinterProfile {
        guard
            let ID = json["id"] as? String,
            let model = json["model"] as? String,
            let name = json["name"] as? String else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return PrinterProfile(ID: ID, model: model, name: name)
    }
}
