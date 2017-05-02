//
//  PrinterState+JSONAble.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension PrinterState: JSONAble {
    static func fromJSON(json: [String : Any]) throws -> PrinterState {
        guard
            let stateJSON = json["state"] as? [String: Any],
            let state = stateJSON["text"] as? String
        else {
            throw JSONAbleError.errorMappingJSONToObject(json: json)
        }

        return PrinterState(state: state)
    }
}
