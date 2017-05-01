//
//  ControlsViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Controls logic inputs
protocol ControlsViewModelInputs {
    /// Call to move printer head forward
    func moveHeadForward()

    /// Call to move printer head backward
    func moveHeadBackward()

    /// Call to move printer head to the left
    func moveHeadLeft()

    /// Call to move printer head to the right
    func moveHeadRight()

    /// Call to move printer head up
    func moveHeadUp()

    /// Call to move printer head down
    func moveHeadDown()

    /// Call to move printer head home on X and Y axis
    func moveHeadHomeXY()

    /// Call to move printer head home on Z axis
    func moveHeadHomeZ()
}

// MARK: - Outputs

/// Controls logic output
protocol ControlsViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Stream of displayable errors
    var displayError: SignalProducer<DisplayableError, NoError> { get }
}

// MARK: - Common public interface

/// Common interface for controls logic
protocol ControlsViewModelType {
    /// Available inputs
    var inputs: ControlsViewModelInputs { get }

    /// Available outputs
    var outputs: ControlsViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Controls screen logic
final class ControlsViewModel: ControlsViewModelType, ControlsViewModelInputs, ControlsViewModelOutputs {
    var inputs: ControlsViewModelInputs { return self }

    var outputs: ControlsViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property(value: tr(.printerControls))

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Holds last error occured
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    // MARK: Initializers

    init(provider: OctoPrintProvider) {
        self.provider = provider
        self.displayError = displayErrorProperty.producer.skipNil()
    }

    // MARK: Input methods

    func moveHeadForward() {
        movePrintHead(axis: .y, direction: .increase)
    }

    func moveHeadBackward() {
        movePrintHead(axis: .y, direction: .decrease)
    }

    func moveHeadLeft() {
        movePrintHead(axis: .x, direction: .decrease)
    }

    func moveHeadRight() {
        movePrintHead(axis: .x, direction: .increase)
    }

    func moveHeadUp() {
        movePrintHead(axis: .z, direction: .increase)
    }

    func moveHeadDown() {
        movePrintHead(axis: .z, direction: .decrease)
    }

    func moveHeadHomeXY() {
        homePrintHead(axes: [.x, .y])
    }

    func moveHeadHomeZ() {
        homePrintHead(axes: [.z])
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Creates request for print head move
    ///
    /// - Parameters:
    ///   - axis: Axis of move
    ///   - direction: Direction in which the print head is moved
    private func movePrintHead(axis: JogAxis, direction: JogDirection) {
        printHeadRequest(.jogPrintHead(axis, direction))
    }

    /// Creates request to move print head to home in given axes
    ///
    /// - Parameter axes: Axes used to home the print head
    private func homePrintHead(axes: [JogAxis]) {
        printHeadRequest(.homePrintHead(Set(axes)))
    }

    /// General print head request observed for error
    ///
    /// - Parameter request: Request which should be made
    private func printHeadRequest(_ request: OctoPrintAPI) {
        provider.request(request)
            .filterSuccessfulStatusCodes()
            .startWithFailed { [weak self] _ in
                self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                    tr(.printHeadCommandCouldNotBeIssued))
            }
    }
}
