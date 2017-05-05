//
//  DetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result
import class UIKit.UIImage
import Moya
import Icons

// MARK: - Inputs

/// Printer detail logic inputs
protocol DetailViewModelInputs {
    /// Call when screen is about to appear
    func viewWillAppear()

    /// Call when user tap on controls button
    func controlsButtonTapped()

    /// Call when user tap on connect printer button
    func connectButtonTapped()
}

// MARK: - Outputs

/// Printer detail logic outputs
protocol DetailViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Indicates whether the content is currently available
    var contentIsAvailable: Property<Bool> { get }

    /// Text representation of printer state
    var printerState: Property<String> { get }

    /// Preview image of job or placeholder if it's not available
    var jobPreview: Property<UIImage> { get }

    /// Title of current job
    var jobTitle: Property<String> { get }

    /// Name of currently printed file
    var fileName: Property<String> { get }

    /// Indicates for how long is file beeing printed
    var printTime: Property<String> { get }

    /// Estimated timed of print end
    var estimatedPrintTime: Property<String> { get }

    /// Current temperature of printer bed
    var bedTemperature: Property<String> { get }

    /// Target temperature of printer bed
    var bedTemperaturTarget: Property<String> { get }

    /// Printer bed offset temperature
    var bedTemperatureOffset: Property<String> { get }

    /// Streams which indicates when data should be reloaded
    var dataChanged: SignalProducer<(), NoError> { get }
}

// MARK: - Common public interface

/// Common interface for detail View Models
protocol DetailViewModelType {
    /// Available inputs
    var inputs: DetailViewModelInputs { get }

    /// Available outputs
    var outputs: DetailViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Printer detail logic
final class DetailViewModel: DetailViewModelType, DetailViewModelInputs, DetailViewModelOutputs {
    var inputs: DetailViewModelInputs { return self }

    var outputs: DetailViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property(value: tr(.printerDetail))

    let contentIsAvailable: Property<Bool>

    let printerState: Property<String>

    let jobPreview: Property<UIImage>

    let jobTitle: Property<String>

    let fileName: Property<String>

    let printTime: Property<String>

    let estimatedPrintTime: Property<String>

    let bedTemperature: Property<String>

    let bedTemperaturTarget: Property<String>

    let bedTemperatureOffset: Property<String>

    let dataChanged: SignalProducer<(), NoError>

    // MARK: Private properties

    let contentIsAvailableProperty = MutableProperty(false)

    let bedProperty = MutableProperty<Bed?>(nil)

    let jobProperty = MutableProperty<Job?>(nil)

    let stateProperty = MutableProperty<PrinterState?>(nil)

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Detail flow delegate
    private weak var delegate: DetailViewControllerDelegate?

    // MARK: Initializers

    init(delegate: DetailViewControllerDelegate, provider: OctoPrintProvider) {
        self.delegate = delegate
        self.provider = provider

        let stateProducer = stateProperty.producer.skipNil()
        let jobProducer = jobProperty.producer.skipNil()
        let bedProducer = bedProperty.producer.skipNil()

        self.contentIsAvailable = Property(capturing: contentIsAvailableProperty)
        self.printerState = Property(initial: tr(.unknown), then: stateProducer.map({ $0.state }))
        self.jobPreview = Property(value: FontAwesomeIcon.lightBulbIcon.image(ofSize: CGSize(width: 60, height: 60),
                                                                              color: Colors.Pallete.greyHue3))
        self.jobTitle = Property(initial: tr(.unknown),
                                 then: jobProducer.map({ $0.fileName }).skipNil())
        self.fileName = Property(initial: tr(.unknown),
                                 then: jobProducer.map({ $0.fileName }).skipNil())
        self.printTime = Property(initial: tr(.unknown),
                                  then: jobProducer.map({ $0.printTime.value }).skipNil().formatDuration())
        self.estimatedPrintTime = Property(initial: tr(.unknown),
                                           then: jobProducer.map({ $0.printTimeLeft.value }).skipNil().formatDuration())
        self.bedTemperature = Property(initial: tr(.unknown),
                                       then: bedProducer.map({ $0.actualTemperature }).formatTemperature())
        self.bedTemperaturTarget = Property(initial: tr(.unknown),
                                            then: bedProducer.map({ $0.targetTemperature }).formatTemperature())
        self.bedTemperatureOffset = Property(initial: tr(.unknown),
                                             then: bedProducer.map({ $0.offsetTemperature }).formatTemperature())

        let dataChanged = SignalProducer.combineLatest(stateProducer, jobProducer, bedProducer).ignoreValues()

        self.dataChanged = SignalProducer.merge([dataChanged, contentIsAvailable.producer.ignoreValues()])

        requestData()
    }

    // MARK: Input methods

    // MARK: Output methods

    func controlsButtonTapped() {
        delegate?.controlsButtonTapped()
    }

    func connectButtonTapped() {
        delegate?.connectButtonTapped()
    }

    func viewWillAppear() {
        requestData()
    }

    // MARK: Internal logic

    /// Requests all needed data for printer detail screen,
    /// chains PrinterState, CurrentJob and CurrentBedState requests
    private func requestData() {
        provider.request(.currentPrinterState)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapTo(object: PrinterState.self)
            .flatMap(FlattenStrategy.latest) { state -> SignalProducer<Any, MoyaError> in
                self.stateProperty.value = state
                return self.provider.request(.currentJob).filterSuccessfulStatusCodes().mapJSON()
            }
            .mapTo(object: Job.self)
            .flatMap(FlattenStrategy.latest) { job -> SignalProducer<Any, MoyaError> in
                self.jobProperty.value = job
                return self.provider.request(.currentBedState).filterSuccessfulStatusCodes().mapJSON()
            }
            .mapTo(object: Bed.self, forKeyPath: "bed")
            .startWithResult { result in
                if case let .success(bed) = result {
                    self.bedProperty.value = bed
                    self.contentIsAvailableProperty.value = true
                }

                if case .failure = result {
                    self.contentIsAvailableProperty.value = false
                }
            }
    }
}
