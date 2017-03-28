//
//  String+URLEncoded.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 28/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension String {
    /// Encoded string representation of URL component
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
