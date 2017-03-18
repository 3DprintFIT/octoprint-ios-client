//
//  Command.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 14/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents status of command when it is sent to printer
///
/// - processing: Command was send but printer did not respond yet
/// - failed: Command failed to process or failed to send
/// - success: Command was send and processed by printer successfully
enum CommandStatus: String {
    case processing
    case failed
    case success
}

/// Arbitrary printer command object
final class Command: Object {

    // MARK: Properties

    /// Actual value of command
    dynamic var value = ""

    /// Stored value of command status
    private dynamic var _status = CommandStatus.processing.rawValue

    /// Current command status
    var status: CommandStatus {
        get {
            return CommandStatus(rawValue: _status)!
        } set {
            _status = newValue.rawValue
        }
    }

    // MARK: Initializers

    convenience init(value: String, status: CommandStatus = .processing) {
        self.init()

        self.value = value
        self.status = status
    }

    // MARK: Realm API

    override static func ignoredProperties() -> [String] {
        return ["status"]
    }
}
