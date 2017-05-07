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

    /// Call when user changed target temperature
    ///
    /// - Parameter value: New value of target temperature
    func targetTemperatureChanged(_ value: String?)

    /// Call when user changed offset temperature
    ///
    /// - Parameter value: New value of offset temperature
    func offsetTemperatureChanged(_ value: String?)
}

// MARK: - Outputs

/// Outputs of bed settings logic
protocol BedSettingsViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Stream of displayable errors
    var displayError: SignalProducer<DisplayableError, NoError> { get }
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

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Actual value of target temperature
    private let targetTemperatureProperty = MutableProperty<String?>(nil)

    /// Actual value of offset temperature
    private let offsetTemperatureProperty = MutableProperty<String?>(nil)

    /// Holds last occured error
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Bed settings flow delegate
    private weak var delegate: BedSettingsViewControllerDelegate?

    /// Printer requests provider
    private let provider: OctoPrintProvider

    // MARK: Initializers

    init(delegate: BedSettingsViewControllerDelegate, provider: OctoPrintProvider) {
        self.delegate = delegate
        self.provider = provider
        self.displayError = displayErrorProperty.producer.skipNil()

        targetTemperatureProperty.producer.skipNil()
            .map({ Double($0) }).skipNil()
            .filter({ $0 >= 0 })
            .debounce(1, on: QueueScheduler.main)
            .skipRepeats()
            .startWithValues { [weak self] temperature in
                self?.setTemperature(temprature: temperature, type: .target)
            }

        offsetTemperatureProperty.producer.skipNil()
            .map({ Double($0) }).skipNil()
            .debounce(1, on: QueueScheduler.main)
            .skipRepeats()
            .startWithValues { [weak self] temperature in
                self?.setTemperature(temprature: temperature, type: .offset)
            }
    }

    // MARK: Input methods

    func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }

    func targetTemperatureChanged(_ value: String?) {
        targetTemperatureProperty.value = value
    }

    func offsetTemperatureChanged(_ value: String?) {
        offsetTemperatureProperty.value = value
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Sets the given temperature to the printer bed
    ///
    /// - Parameters:
    ///   - temprature: Amount of degrees
    ///   - type: Type bed temperature
    private func setTemperature(temprature: Double, type: BedTemperatureType) {
        provider.request(.setBedTemperature(amout: temprature, type))
            .filterSuccessfulStatusCodes()
            .startWithFailed { [weak self] _ in
                self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                    tr(.couldNotSetBedTemperature))
            }
    }
}
