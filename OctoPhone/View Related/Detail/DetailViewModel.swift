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

    /// Call when user want to cancel current print job
    func cancelJobButtonTapped()

    /// Call when user tapped on bed temperature cell to display temperature settings
    func bedCellTapped()
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

    /// Current temperature of printer tool
    var toolTemperature: Property<String> { get }

    /// Target temperature of printer tool
    var toolTemperaturTarget: Property<String> { get }

    /// Printer tool offset temperature
    var toolTemperatureOffset: Property<String> { get }

    /// Indicates whether the current job is cancellable
    var jobCancellable: Property<Bool> { get }

    /// Streams which indicates when data should be reloaded
    var dataChanged: SignalProducer<(), NoError> { get }

    /// Stream of errors displayable to user
    var displayError: SignalProducer<DisplayableError, NoError> { get }
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

    let toolTemperature: Property<String>

    let toolTemperaturTarget: Property<String>

    let toolTemperatureOffset: Property<String>

    let jobCancellable: Property<Bool>

    let dataChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Current printer value
    private let printerProperty = MutableProperty<Printer?>(nil)

    /// Indicates whether the content is available, broadcasts its value
    private let contentIsAvailableProperty = MutableProperty(false)

    /// Current bed value
    private let bedProperty = MutableProperty<Bed?>(nil)

    /// Current job value
    private let jobProperty = MutableProperty<Job?>(nil)

    /// Current state value
    private let stateProperty = MutableProperty<PrinterState?>(nil)

    private let toolProperty = MutableProperty<Tool?>(nil)

    /// Last error occured
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Stream image
    private let imageProperty = MutableProperty<UIImage?>(nil)

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// User content requests provider
    private let staticProvider = StaticContentProvider()

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Timer to download stream image
    private var streamTimerDisposable: Disposable?

    /// Detail flow delegate
    private weak var delegate: DetailViewControllerDelegate?

    // MARK: Initializers
    // swiftlint:disable function_body_length
    init(delegate: DetailViewControllerDelegate, provider: OctoPrintProvider,
         contextManager: ContextManagerType, printerID: String) {

        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager

        let streamTimer = timer(interval: DispatchTimeInterval.seconds(10), on: QueueScheduler.main)

        let stateProducer = stateProperty.producer.skipNil()
        let jobProducer = jobProperty.producer.skipNil()
        let bedProducer = bedProperty.producer.skipNil()
        let printerProducer = printerProperty.producer.skipNil()
        let toolProducer = toolProperty.producer.skipNil()
        let imageProducer = imageProperty.producer.skipNil()

        self.displayError = displayErrorProperty.producer.skipNil()
        self.contentIsAvailable = Property(capturing: contentIsAvailableProperty)
        self.printerState = Property(initial: tr(.unknown), then: stateProducer.map({ $0.state }))
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
        self.toolTemperature = Property(initial: tr(.unknown),
                                        then: toolProducer.map({ $0.actualTemperature }).formatTemperature())
        self.toolTemperaturTarget = Property(initial: tr(.unknown),
                                             then: toolProducer.map({ $0.targetTemperature }).formatTemperature())
        self.toolTemperatureOffset = Property(initial: tr(.unknown),
                                             then: toolProducer.map({ $0.offsetTemperature }).formatTemperature())
        self.jobPreview = Property(initial: FontAwesomeIcon.lightBulbIcon.image(ofSize: CGSize(width: 60, height: 60),
                                                                                color: Colors.Pallete.greyHue3),
                                   then: imageProducer)

        let dataChanged = SignalProducer.combineLatest(stateProducer, jobProducer, bedProducer,
                                                       printerProperty.producer).ignoreValues()

        let jobCancellable = SignalProducer.combineLatest(
            jobProducer.map(DetailViewModel.validJob),
            contentIsAvailable.producer
        ).map({ return $0 && $1 })

        self.jobCancellable = Property(initial: false, then: jobCancellable)
        self.dataChanged = SignalProducer.merge([dataChanged, contentIsAvailable.producer.ignoreValues()])

        printerProducer.map({ $0.streamUrl }).skipNil().flatMap(.latest) { url in
            return self.staticProvider.request(.get(url))
        }
        .startWithResult { [weak self] result in
            switch result {
            case let .success(response): self?.imageProperty.value = UIImage(data: response.data)
            case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                               tr(.couldNotLoadPrinterStream))
            }
        }

        self.streamTimerDisposable = streamTimer.startWithValues { [weak self] _ in
            self?.printerProperty.value = self?.printerProperty.value
        }

        loadPrinter(with: printerID)
        requestData()
    }

    // MARK: Input methods

    func controlsButtonTapped() {
        delegate?.controlsButtonTapped()
    }

    func connectButtonTapped() {
        delegate?.connectButtonTapped()
    }

    func viewWillAppear() {
        requestData()
    }

    func cancelJobButtonTapped() {
        cancelPrintJob()
    }

    func bedCellTapped() {
        delegate?.bedCellTapped()
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Loads printer object from local storage by it's identifier
    ///
    /// - Parameter printerID: Identifier of printer which will be loaded
    private func loadPrinter(with printerID: String) {
        self.contextManager.createObservableContext()
            .fetch(Printer.self, forPrimaryKey: printerID)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(printer): self?.printerProperty.value = printer
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.couldNotLoadPrinter))
                }
            }
    }

    /// Requests all needed data for printer detail screen,
    /// chains PrinterState, CurrentJob and CurrentBedState requests
    private func requestData() {
        provider.request(.currentPrinterState)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapTo(object: PrinterState.self)
            .flatMap(.latest) { state -> SignalProducer<Any, MoyaError> in
                self.stateProperty.value = state
                return self.provider.request(.currentJob).filterSuccessfulStatusCodes().mapJSON()
            }
            .mapTo(object: Job.self)
            .flatMap(.latest) { job -> SignalProducer<Any, MoyaError> in
                self.jobProperty.value = job
                return self.provider.request(.currentToolState).filterSuccessfulStatusCodes().mapJSON()
            }
            .mapDictionary(collectionOf: Tool.self)
            .flatMap(.latest) { tools -> SignalProducer<Any, MoyaError> in
                self.toolProperty.value = tools.first
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

    /// Cancels current print job and refreshes current data screen
    private func cancelPrintJob() {
        provider.request(.cancelJob)
            .startWithResult { [weak self] _ in
                self?.requestData()
            }
    }

    /// Determines whether the job is valid
    ///
    /// - Parameter job: Job to be validated
    /// - Returns: True if job is valid, false otherwise
    private static func validJob(_ job: Job) -> Bool {
        return job.fileName != nil && job.fileSize.value != nil && job.printTimeLeft.value != nil
    }

    deinit {
        streamTimerDisposable?.dispose()
    }
}
