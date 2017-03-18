//
//  Log.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 18/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Log file object
final class Log: Object {

    // MARK: - Stored properties

    /// File name
    dynamic var name = ""

    /// The size of file in bytes
    dynamic var size = 0

    /// Timestamp of last modification
    dynamic var lastModified = 0

    /// Download path for the file
    dynamic var remotePath = ""

    /// Reference path for the file, identifies the file
    dynamic var referencePath = ""

    /// Local path for the file
    dynamic var localPath: String?

    // MARK: - Computed properties

    /// Indicates whether the file was already downloaded
    var isDownloaded: Bool {
        return localPath != nil
    }

    // MARK: - Public API

    convenience init(name: String, size: Int, lastModified: Int, remotePath: String,
                     referencePath: String, localPath: String? = nil) {

        self.init()

        self.name = name
        self.size = size
        self.lastModified = lastModified
        self.remotePath = remotePath
        self.referencePath = referencePath
        self.localPath = localPath
    }

    // MARK: - Realm API

    override static func primaryKey() -> String? {
        return "referencePath"
    }
}
