//
//  OPFileSizeFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Standard formatted for file sizes
struct OPFileSizeFormatter {
    /// Creates human readable size format from bytes (adds KB, MB, etc)
    ///
    /// - Parameter bytes: Actual file size in bytes
    /// - Returns: Formatted size string
    static func sizeFromBytes(_ bytes: Int) -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .binary)
    }
}
