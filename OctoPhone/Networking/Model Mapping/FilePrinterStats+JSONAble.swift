//
//  FilePrinterStats+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension FilePrintStats: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> FilePrintStats {
        guard
            let failures = json["failure"] as? Int,
            let successes = json["success"] as? Int,
            let lastJSON = json["last"] as? [String: Any],
            let lastPrint = lastJSON["date"] as? Int,
            let lastSucccess = lastJSON["success"] as? Bool else
        {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return FilePrintStats(failures: failures, successes: successes, lastPrint: lastPrint,
                              wasLastPrintSuccess: lastSucccess)
    }
}
