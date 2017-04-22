//
//  Job+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 22/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension Job: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> Job {
        guard
            let job = json["job"] as? [String: Any],
            let progress = json["progress"] as? [String: Any],
            let state = json["state"] as? String,
            let file = job["file"] as? [String: Any],
            let fileName = file["name"] as? String,
            let fileSize = file["size"] as? Int,
            let completion = progress["completion"] as? Double,
            let printTime = progress["printTime"] as? Int,
            let printTimeLeft = progress["printTimeLeft"] as? Int
        else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return Job(fileName: fileName, fileSize: fileSize, completion: completion,
                   printTime: printTime, printTimeLeft: printTimeLeft, state: state)
    }
}
