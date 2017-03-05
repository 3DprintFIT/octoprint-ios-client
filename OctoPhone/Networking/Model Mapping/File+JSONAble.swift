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
            let path = json["path"] as? String,
            let typeStr = json["type"] as? String,
            let type = FileType(rawValue: typeStr),
            let originStr = json["origin"] as? String,
            let origin = FileOrigin(rawValue: originStr),
            let size = json["size"] as? Int,
            let date = json["date"] as? Int,
            let refs = json["refs"] as? [String: Any],
            let resource = refs["resource"] as? String,
            let download = refs["download"] as? String,
            let analysisJSON = json["gcodeAnalysis"] as? [String: Any],
            let statsJSON = json["print"] as? [String: Any] else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        let analysis = try GCodeAnalysis.fromJSON(json: analysisJSON)
        let stats = try FilePrintStats.fromJSON(json: statsJSON)

        return File(name: name, path: path, type: type, origin: origin, size: size, date: date,
                    resource: resource, download: download, gcodeAnalysis: analysis,
                    printStats: stats)
    }
}
