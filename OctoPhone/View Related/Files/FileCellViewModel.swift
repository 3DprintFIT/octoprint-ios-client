//
//  FileCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// File cell user inputs
protocol FileCellViewModelInputs {

}

// MARK: - Outputs

/// File cell view outputs
protocol FileCellViewModelOutputs {
    /// Name of the file
    var fileName: Property<String> { get }
}

// MARK: - Common public interface

/// Common protocol for file cell View Models
protocol FileCellViewModelType {
    /// Available inputs
    var inputs: FileCellViewModelInputs { get }

    /// Available outputs
    var outputs: FileCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// File cell logic
final class FileCellViewModel: FileCellViewModelType, FileCellViewModelInputs,
FileCellViewModelOutputs {
    var inputs: FileCellViewModelInputs { return self }

    var outputs: FileCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let fileName: Property<String>

    // MARK: Private properties

    // MARK: Initializers

    init(file: File) {
        self.fileName = Property(value: file.name)
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
