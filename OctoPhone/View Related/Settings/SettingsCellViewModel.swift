//
//  SettingsCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/// Settings view model output
protocol SettingsCellViewModelOutputs {
    /// Display name of setting
    var name: SignalProducer<String, NoError> { get }
}

/// Coomon interface for settings cell view model
protocol SettingsCellViewModelType {
    /// Available outputs
    var outputs: SettingsCellViewModelOutputs { get }
}

/// Logic for settings cell
final class SettingsCellViewModel: SettingsCellViewModelType, SettingsCellViewModelOutputs {

    var outputs: SettingsCellViewModelOutputs { return self }

    // MARK: - Outputs
    let name: SignalProducer<String, NoError>

    init(name: String) {
        self.name = SignalProducer(value: name)
    }
}
