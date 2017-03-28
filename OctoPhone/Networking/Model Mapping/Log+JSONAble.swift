//
//  Log+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension Log: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> Log {
        guard
            let lastModified = json["date"] as? Int,
            let name = json["name"] as? String,
            let size = json["size"] as? Int,
            let referenceJSON = json["refs"] as? [String: Any],
            let fullRemotePath = referenceJSON["download"] as? String,
            let remotePath = URL(string: fullRemotePath),
            let referencePath = referenceJSON["resource"] as? String else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return Log(name: name, size: size, lastModified: lastModified,
                   remotePath: remotePath.lastPathComponent, referencePath: referencePath)
    }
}
