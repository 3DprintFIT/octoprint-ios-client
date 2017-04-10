//
//  FileDetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// File detail inputs
protocol FileDetailViewModelInputs {

}

// MARK: - Outputs

/// File detail outputs
protocol FileDetailViewModelOutputs {
    /// Title for view controller
    var screenTitle: Property<String> { get }

    /// Heading text for attributes section
    var attributesHeading: Property<String> { get }

    /// Label text for file name
    var fileNameLabel: Property<String> { get }

    /// Filename value
    var fileName: Property<String> { get }

    /// Label text for size
    var sizeLabel: Property<String> { get }

    /// Size value
    var size: Property<String> { get }

    /// Label text for file type
    var typeLabel: Property<String> { get }

    /// File type value
    var type: Property<String> { get }

    /// Label text for last modification
    var lastModificationLabel: Property<String> { get }

    /// Date of last file modification
    var lastModification: Property<String> { get }

    /// Heading text for analysis section
    var analysisHeading: Property<String> { get }

    /// Label text for filament length
    var filamentLengthLabel: Property<String> { get }

    /// Aproximate length of needed filament
    var filamentLength: Property<String> { get }

    /// Label text for filament volume
    var filamentVolumeLabel: Property<String> { get }

    /// Aproximate volume of needed filament
    var filamentVolume: Property<String> { get }

    /// Print stats heading text
    var statsHeading: Property<String> { get }

    /// Label for number of successful prints
    var printSuccessesLabel: Property<String> { get }

    /// Number of successful prints
    var printSuccesses: Property<String> { get }

    /// Label for number of failed prints
    var printFailuresLabel: Property<String> { get }

    /// Number of failed prints
    var printFailures: Property<String> { get }

    /// Indicates whether the analysis section should be visible
    var analysisSectionIsEnabled: Property<Bool> { get }

    /// Indicates whether the stats section should be visible
    var statsSectionIsEnabled: Property<Bool> { get }
}

// MARK: - Common public interface

/// Common protocol for file detail View Models
protocol FileDetailViewModelType {
    /// Available inputs
    var inputs: FileDetailViewModelInputs { get }

    /// Available outputs
    var outputs: FileDetailViewModelOutputs { get }
}

// MARK: - View Model implementation

/// File detail controller logic
final class FileDetailViewModel: FileDetailViewModelType, FileDetailViewModelInputs, FileDetailViewModelOutputs {
    var inputs: FileDetailViewModelInputs { return self }

    var outputs: FileDetailViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let screenTitle: Property<String>

    let attributesHeading = Property(value: tr(.fileAttributes).uppercased())

    let fileNameLabel = Property<String>(value: tr(.fileName))

    let fileName: Property<String>

    let sizeLabel = Property<String>(value: tr(.fileSize))

    let size: Property<String>

    let typeLabel = Property<String>(value: tr(.fileType))

    let type: Property<String>

    let lastModificationLabel = Property<String>(value: tr(.fileLastModification))

    let lastModification: Property<String>

    let analysisHeading = Property(value: tr(.fileAnalysis).uppercased())

    let filamentLengthLabel = Property<String>(value: tr(.fileFilamentLength))

    let filamentLength: Property<String>

    let filamentVolumeLabel = Property<String>(value: tr(.fileFilamentVolume))

    var filamentVolume: Property<String>

    let statsHeading = Property(value: tr(.fileStats).uppercased())

    let printSuccessesLabel = Property<String>(value: tr(.fileSuccessPrints))

    let printSuccesses: Property<String>

    let printFailuresLabel = Property<String>(value: tr(.fileFailurePrints))

    let printFailures: Property<String>

    let analysisSectionIsEnabled: Property<Bool>

    let statsSectionIsEnabled: Property<Bool>

    // MARK: Private properties

    /// Identifier of file which detail is presented
    private let fileID: String

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual printer file
    private let fileProperty = MutableProperty<File?>(nil)

    // MARK: Initializers

    init(fileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.fileID = fileID
        self.provider = provider
        self.contextManager = contextManager

        let fileProducer = fileProperty.producer.skipNil()
        let analysisProducer = fileProducer.map { $0.gcodeAnalysis }.skipNil()
        let statsProducer = fileProducer.map { $0.printStats }.skipNil()

        self.screenTitle = Property(value: fileID)
        self.fileName = Property(initial: tr(.unknownFile), then: fileProducer.map({ $0.name }))
        self.size = Property(initial: tr(.unknown),
                             then: fileProducer.map({ $0.size }).formatFileSize())
        self.type = Property(initial: tr(.unknown), then: fileProducer.map { file in
            return file.type == . model ? tr(.stlModel) : tr(.gcodeFile)
        })
        self.lastModification = Property(initial: tr(.unknown),
                                         then: fileProducer.map({ $0.date }).formatDate())
        self.filamentLength = Property(initial: tr(.unknown),
                                       then: analysisProducer.map({ $0.filamentLength }).formatLength())
        self.filamentVolume = Property.init(initial: tr(.unknown),
                                            then: analysisProducer.map({ $0.filamentLength }).formatVolume())
        self.printSuccesses = Property(initial: tr(.unknown),
                                       then: statsProducer.map({ $0.successes }).formatNumber())
        self.printFailures = Property(initial: tr(.unknown),
                                      then: statsProducer.map({ $0.failures}).formatNumber())
        self.analysisSectionIsEnabled = Property(initial: false,
                                                 then: fileProducer.map { $0.gcodeAnalysis != nil })
        self.statsSectionIsEnabled = Property(initial: false,
                                              then: fileProducer.map { $0.printStats != nil })

        contextManager.createObservableContext()
            .fetch(File.self, forPrimaryKey: fileID)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(file): self?.fileProperty.value = file
                case .failure: break
                }
            }
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
