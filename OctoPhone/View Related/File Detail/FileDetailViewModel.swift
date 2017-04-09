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
    var screenTitle: Property<String> { get }
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

    // MARK: Private properties

    /// Identifier of file which detail is presented
    private let fileID: String

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    // MARK: Initializers

    init(fileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.fileID = fileID
        self.provider = provider
        self.contextManager = contextManager

        self.screenTitle = Property(value: fileID)
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
