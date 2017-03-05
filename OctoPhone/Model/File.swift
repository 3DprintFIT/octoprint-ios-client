//
//  File.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Stored file at printer or sdcard
final class File: Object {

    // MARK: - Stored properties

    /// File name
    dynamic var name = ""

    /// Serialized value of file type
    private dynamic var _type = FileType.machineCode.rawValue

    /// Srialized value of file origin
    private dynamic var _origin = FileOrigin.local.rawValue

    /// Size of file
    dynamic var size = 0

    /// Creation date
    dynamic var date = 0

    /// API resource path
    dynamic var resource = ""

    /// Download path
    dynamic var download = ""

    /// GCode analysis
    dynamic var gcodeAnalysis: GCodeAnalysis?

    /// Print statistics informations
    dynamic var printStats: FilePrintStats?

    // MARK: - Computed properties    
    /// File type
    var type: FileType {
        get {
            return FileType(rawValue: _type)!
        } set {
            _type = newValue.rawValue
        }
    }

    /// File origin
    var origin: FileOrigin {
        get {
            return FileOrigin(rawValue: _origin)!
        } set {
            _origin = newValue.rawValue
        }
    }

    // MARK: Public API

    /// Creates new File object
    ///
    /// - Parameters:
    ///   - name: File name
    ///   - type: File type
    ///   - origin: File origin
    ///   - size: File size
    ///   - date: Creation date
    ///   - resource: API resource path
    ///   - download: Download path
    ///   - gcodeAnalysis: GCode analysis
    ///   - printStats: Print statistics
    convenience init(name: String, type: FileType, origin: FileOrigin, size: Int, date: Int,
                     resource: String, download: String, gcodeAnalysis: GCodeAnalysis? = nil,
                     printStats: FilePrintStats? = nil) {

        self.init()

        self.name = name
        self._type = type.rawValue
        self._origin = origin.rawValue
        self.size = size
        self.date = date
        self.resource = resource
        self.download = download
        self.gcodeAnalysis = gcodeAnalysis
        self.printStats = printStats
    }

    // MARK: Realm API

    override static func primaryKey() -> String? {
        return "name"
    }

    override static func ignoredProperties() -> [String] {
        return ["type", "origin"]
    }
}

/// Supported file type
///
/// - model: Printed object model
/// - machineCode: Printed object code
/// - folder: Folder
enum FileType: String {
    case model
    case machineCode = "machinecode"
    case folder
}

/// Represents where the file is stored
///
/// - local: File is stored on OctoPrint disk
/// - sdcard: File is stored on SD card
enum FileOrigin: String {
    case local
    case sdcard
}
