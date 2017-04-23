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
        guard let ID = json["key"] as? String else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        let isDefault = json["default"] as? Bool ?? false

        return SlicingProfile(ID: ID, name: json["displayName"] as? String,
                              description: json["description"] as? String, isDefault: isDefault)
    }
}
