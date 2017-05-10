//
//  BonjourService.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

/// Represents correctly resolved service
struct BonjourService {
    /// Service human readable name
    var name: String

    /// Service IP address with port
    var address: String

    /// Port on which is the service accessible
    var port: String

    /// Returns full address on which is the service available.
    /// This includes the IP and port.
    var fullAddress: String {
        return "\(address):\(port)"
    }
}
