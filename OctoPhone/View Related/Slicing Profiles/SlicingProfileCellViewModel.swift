//
//  SlicingProfileCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// View model logic inputs
protocol SlicingProfileCellViewModelInputs {

}

// MARK: - Outputs

/// View model logic outputs
protocol SlicingProfileCellViewModelOutputs {
    /// Profile name
    var name: Property<String> { get }
}

// MARK: - Common public interface

/// Common protocol for cell view model
protocol SlicingProfileCellViewModelType {
    /// Available inputs
    var inputs: SlicingProfileCellViewModelInputs { get }

    /// Available outputs
    var outputs: SlicingProfileCellViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Slicing profile cell View model
final class SlicingProfileCellViewModel: SlicingProfileCellViewModelType, SlicingProfileCellViewModelInputs,
SlicingProfileCellViewModelOutputs {
    var inputs: SlicingProfileCellViewModelInputs { return self }

    var outputs: SlicingProfileCellViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let name: Property<String>

    // MARK: Private properties

    /// Database connection manager
    private let contextManager: ContextManagerType

    // MARK: Initializers

    init(profileID: String, contextManager: ContextManagerType) {
        let profileProducer = contextManager.createObservableContext()
            .fetch(SlicingProfile.self, forPrimaryKey: profileID)
            .skipNil()
            .skipError()

        self.contextManager = contextManager
        self.name = Property(initial: tr(.unknownSlicingProfile),
                             then: profileProducer.map({ $0.name }).skipNil())
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
