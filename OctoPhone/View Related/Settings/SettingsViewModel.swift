//
//  SettingsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Settings page inputs
protocol SettingsViewModelInputs {

}

/// Outputs for view controller
protocol SettingsViewModelOutputs {

}

/// Common interface for settings view model
protocol SettingsViewModelType {
    /// Available view model inputs
    var inputs: SettingsViewModelInputs { get }

    /// Available view model outputs
    var outputs: SettingsViewModelOutputs { get }
}

/// Settings controller logic
final class SettingsViewModel: SettingsViewModelType, SettingsViewModelInputs,
SettingsViewModelOutputs {

    var inputs: SettingsViewModelInputs { return self }

    var outputs: SettingsViewModelOutputs { return self }
}
