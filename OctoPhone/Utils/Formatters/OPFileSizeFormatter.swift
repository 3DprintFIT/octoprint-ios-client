//
//  OPFileSizeFormatter.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

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

extension SignalProducer where Value == Int {
    /// Operator for file size number format. Maps given values of `self`
    /// to string representation file size. Also appends correct unit sign.
    ///
    /// - Returns: Producer with formatted value of `self`
    func formatFileSize() -> SignalProducer<String, Error> {
        return map { OPFileSizeFormatter.sizeFromBytes($0) }
    }
}
