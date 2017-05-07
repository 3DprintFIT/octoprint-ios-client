//
//  BedSettingsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Inputs for bed settings logic
protocol BedSettingsViewModelInputs {
    /// Call when user decided to close bed settings
    func doneButtonTapped()
}

// MARK: - Outputs

/// Outputs of bed settings logic
protocol BedSettingsViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }
}

// MARK: - Common public interface

/// Common interface for bed settings ViewModel
protocol BedSettingsViewModelType {
    /// Available inputs
    var inputs: BedSettingsViewModelInputs { get }

    /// Available outputs
    var outputs: BedSettingsViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Bed settings logic
final class BedSettingsViewModel: BedSettingsViewModelType, BedSettingsViewModelInputs, BedSettingsViewModelOutputs {
    var inputs: BedSettingsViewModelInputs { return self }

    var outputs: BedSettingsViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property<String>(value: tr(.bedSettings))

    // MARK: Private properties

    /// Bed settings flow delegate
    private weak var delegate: BedSettingsViewControllerDelegate?

    // MARK: Initializers

    init(delegate: BedSettingsViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: Input methods

    func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }

    // MARK: Output methods

    // MARK: Internal logic
}
