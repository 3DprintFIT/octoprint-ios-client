//
//  SlicerCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift

// MARK: - Inputs

protocol SlicerCellViewModelInputs {

}

// MARK: - Outputs

protocol SlicerCellViewModelOutputs {
    /// Formatted name of slicer
    var slicerName: Property<String> { get }
}

// MARK: - Common public interface

protocol SlicerCellViewModelType {
    /// Available inputs
    var inputs: SlicerCellViewModelInputs { get }

    /// Available outputs
    var outputs: SlicerCellViewModelOutputs { get }
}

// MARK: - View Model implementation

final class SlicerCellViewModel: SlicerCellViewModelType, SlicerCellViewModelInputs, SlicerCellViewModelOutputs {
    var inputs: SlicerCellViewModelInputs { return self }

    var outputs: SlicerCellViewModelOutputs { return self }

    // MARK: Inputs

    let slicerName: Property<String>

    // MARK: Outputs

    // MARK: Private properties

    // MARK: Initializers

    init(slicer: Slicer) {
        self.slicerName = Property(value: slicer.name ?? tr(.unknownSlicer))
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
