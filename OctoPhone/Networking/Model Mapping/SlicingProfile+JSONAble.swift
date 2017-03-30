//
//  SlicingProfile+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension SlicingProfile: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> SlicingProfile {
        guard
            let ID = json["key"] as? String,
            let isDefault = json["default"] as? Bool else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return SlicingProfile(ID: ID, name: json["displayName"] as? String, isDefault: isDefault)
    }
}
