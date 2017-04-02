//
//  File.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension Slicer: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> Slicer {
        guard
            let ID = json["key"] as? String,
            let isDefault = json["default"] as? Bool,
            let profiles = json["profiles"] as? [String: Any] else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        let slicer = Slicer(ID: ID, name: json["displayName"] as? String, isDefault: isDefault)

        for (_, profile) in profiles {
            guard let profileJSON = profile as? [String: Any] else {
                throw JSONAbleError.invalidJSON(json: profiles)
            }

            slicer.slicingProfiles.append(try SlicingProfile.fromJSON(json: profileJSON))
        }

        return slicer
    }
}
