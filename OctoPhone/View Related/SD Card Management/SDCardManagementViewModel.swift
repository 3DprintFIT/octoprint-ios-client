//
//  SDCardManagementViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs
/// SD card management inputs
protocol SDCardManagementViewModelInputs {
    /// Call when user tapped on button to initialize SD card
    func initButtonTapped()

    /// Call when user tapped on button to release SD card
    func releaseButtonTapped()

    /// Call when user tapped on button to refresh SD card content
    func refreshButtonTapped()
}

// MARK: - Outputs
/// SD card management outputs
protocol SDCardManagementViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Indicates whether the refresh button interaction is enabled
    var refreshButtonIsEnabled: Property<Bool> { get }

    /// Indicates whether the init button interaction is enabled
    var initButtonIsEnabled: Property<Bool> { get }

    /// Indicates whether the release button interaction is enabled
    var releaseButtonIsEnabled: Property<Bool> { get }

    /// Current state of SD card
    var state: SignalProducer<String, NoError> { get }

    /// Refresh button text
    var refreshButtonText: Property<String> { get }

    /// Init button text
    var initButtonText: Property<String> { get }

    /// Release button text
    var releaseButtonText: Property<String> { get }

    /// Stream of errors presentable to the user
    var displayError: SignalProducer<DisplayableError, NoError> { get }
}

// MARK: - Common public interface
/// Common interface for SD card managing view models
protocol SDCardManagementViewModelType {
    /// Available inputs
    var inputs: SDCardManagementViewModelInputs { get }

    /// Available outputs
    var outputs: SDCardManagementViewModelOutputs { get }
}

// MARK: - View Model implementation
/// SD Card management logic
final class SDCardManagementViewModel: SDCardManagementViewModelType, SDCardManagementViewModelInputs,
SDCardManagementViewModelOutputs {
    var inputs: SDCardManagementViewModelInputs { return self }

    var outputs: SDCardManagementViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property<String>(value: tr(.sdCardManagement))

    let refreshButtonIsEnabled: Property<Bool>

    let initButtonIsEnabled: Property<Bool>

    let releaseButtonIsEnabled: Property<Bool>

    let state: SignalProducer<String, NoError>

    let refreshButtonText = Property<String>(value: tr(.refreshSDCard))

    let initButtonText = Property<String>(value: tr(.initSDCard))

    let releaseButtonText = Property<String>(value: tr(.releaseSDCard))

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Most actual state of SD card
    private let cardProperty = MutableProperty<SDCard>(SDCard(ready: false))

    /// Broadcasts refresh
    private let refreshStateProperty = MutableProperty<()>(())

    /// Holds latest error occured
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    // MARK: Initializers

    init(provider: OctoPrintProvider) {
        let cardProducer = cardProperty.producer
        self.provider = provider
        self.displayError = displayErrorProperty.producer.skipNil()
        self.initButtonIsEnabled = Property(initial: false, then: cardProducer.map({ !$0.ready }))
        self.releaseButtonIsEnabled = Property(initial: false, then: cardProducer.map({ $0.ready }))
        self.refreshButtonIsEnabled = Property(capturing: initButtonIsEnabled)
        self.state = cardProducer.map({ $0.ready ? tr(.sdCardReady) : tr(.sdCardNotConnected) })

        watchRefresh()
    }

    // MARK: Input methods

    func refreshButtonTapped() {
        issueCommand(.refresh)
    }

    func initButtonTapped() {
        issueCommand(.initialize)
    }

    func releaseButtonTapped() {
        issueCommand(.release)
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Watches for refresh events and requests SD card state when it occures
    private func watchRefresh() {
        let refreshEvent = refreshStateProperty.producer
            .throttle(2.0, on: QueueScheduler.main)
            .flatMap(.latest) {
                return self.provider.request(.sdCardState)
                    .mapJSON()
                    .mapTo(object: SDCard.self)
                    .materialize()
            }

        refreshEvent.map({ $0.error }).skipNil().startWithValues { [weak self] _ in
            self?.displayErrorProperty.value = (tr(.anErrorOccured), tr(.sdCardStateIsNotAvailable))
        }

        refreshEvent.map({ $0.value }).skipNil().startWithValues { [weak self] card in
            self?.cardProperty.value = card
        }
    }

    /// Issues given SD card command to printer
    ///
    /// - Parameter command: Command issued to printer
    private func issueCommand(_ command: SDCardCommand) {
        let commandEvent = provider.request(.sdCardCommand(command))
            .filterSuccessfulStatusCodes()
            .materialize()

        commandEvent.map({ $0.value }).skipNil().startWithValues { [weak self] _ in
            self?.refreshStateProperty.value = ()
        }

        commandEvent.map({ $0.error }).skipNil().startWithValues { [weak self] _ in
            self?.displayErrorProperty.value = (tr(.anErrorOccured), tr(.sdCardCommandFailed))
        }
    }
}
