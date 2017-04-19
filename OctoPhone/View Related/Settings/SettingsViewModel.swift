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
    /// Call when terminal cell is selected
    func terminalCellSelected()

    /// Call when logs cell is selected
    func logsCellSelected()

    /// Call when slicing cell is selected
    func slicingCellSelected()

    /// Call when print profiles cell is selected
    func printProfilesCellSelected()

    /// Call when sd car management cell is selected
    func sdCardManagementCellSelected()

    /// Call when user tapped button to close printer detail
    func closePrinterTapped()
}

/// Outputs for view controller
protocol SettingsViewModelOutputs {
    /// Configured view model for terminal cell
    ///
    /// - Returns: Settings cell view model
    func terminalCellViewModel() -> SettingsCellViewModelType

    /// Configured view model for logs cell
    ///
    /// - Returns: Settings cell view model
    func logsCellViewModel() -> SettingsCellViewModelType

    /// Configured view model for slicing cell
    ///
    /// - Returns: Settings cell view model
    func slicingCellViewModel() -> SettingsCellViewModelType

    /// Configured view model for print profiles cell
    ///
    /// - Returns: Settings cell view model
    func printProfilesCellViewModel() -> SettingsCellViewModelType

    /// Configured view model for cd card management cell
    ///
    /// - Returns: Settings cell view model
    func sdCardManagementCellViewModel() -> SettingsCellViewModelType

    /// Configured close button View Model
    ///
    /// - Returns: New object handling close button
    func closePrinterCellViewModel() -> ClosePrinterCellViewModelType
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

    // MARK: Properties

    /// View controller navigation delegate
    private weak var delegate: SettingsViewControllerDelegate?

    init(delegate: SettingsViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: Inputs

    func terminalCellSelected() {
        delegate?.terminalCellSelected()
    }

    func logsCellSelected() {
        delegate?.logsCellSelected()
    }

    func slicingCellSelected() {
        delegate?.slicingCellSelected()
    }

    func printProfilesCellSelected() {
        delegate?.printProfilesCellSelected()
    }

    func sdCardManagementCellSelected() {
        delegate?.sdCardManagementCellSelected()
    }

    func closePrinterTapped() {
        delegate?.closePrinterTapped()
    }

    // MARK: Outputs
    func terminalCellViewModel() -> SettingsCellViewModelType {
        return SettingsCellViewModel(name: tr(.terminal))
    }

    func logsCellViewModel() -> SettingsCellViewModelType {
        return SettingsCellViewModel(name: tr(.logs))
    }

    func slicingCellViewModel() -> SettingsCellViewModelType {
        return SettingsCellViewModel(name: tr(.slicing))
    }

    func printProfilesCellViewModel() -> SettingsCellViewModelType {
        return SettingsCellViewModel(name: tr(.printProfiles))
    }

    func sdCardManagementCellViewModel() -> SettingsCellViewModelType {
        return SettingsCellViewModel(name: tr(.sdCardManagement))
    }

    func closePrinterCellViewModel() -> ClosePrinterCellViewModelType {
        return ClosePrinterCellViewModel()
    }
}
