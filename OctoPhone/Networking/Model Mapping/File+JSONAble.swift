//
//  File+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension File: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> File {
        guard
            let name = json["name"] as? String,
            let typeStr = json["type"] as? String,
            let type = FileType(rawValue: typeStr),
            let originStr = json["origin"] as? String,
            let origin = FileOrigin(rawValue: originStr),
            let size = json["size"] as? Int,
            let date = json["date"] as? Int,
            let refs = json["refs"] as? [String: Any],
            let resource = refs["resource"] as? String,
            let download = refs["download"] as? String else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        let file = File(name: name, type: type, origin: origin, size: size, date: date,
                    resource: resource, download: download)

        if let analysisJSON = json["gcodeAnalysis"] as? [String: Any] {
            file.gcodeAnalysis = try GCodeAnalysis.fromJSON(json: analysisJSON)
        }

        if let statsJSON = json["prints"] as? [String: Any] {
            file.printStats = try FilePrintStats.fromJSON(json: statsJSON)
        }

        return file
    }
}
