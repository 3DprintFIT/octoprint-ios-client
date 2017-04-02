//
//  SlicingProfileViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift

// MARK: - Inputs

/// Slicing profile detail inputs from Controller
protocol SlicingProfileViewModelInputs {

}

// MARK: - Outputs

/// Slicing profile detail outputs for Controller
protocol SlicingProfileViewModelOutputs {

}

// MARK: - Common public interface

/// Common protocol for detail View Model
protocol SlicingProfileViewModelType {
    /// Available inputs
    var inputs: SlicingProfileViewModelInputs { get }

    /// Available outputs
    var outputs: SlicingProfileViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Slicing profile View Controller logic
final class SlicingProfileViewModel: SlicingProfileViewModelType, SlicingProfileViewModelInputs,
SlicingProfileViewModelOutputs {
    var inputs: SlicingProfileViewModelInputs { return self }

    var outputs: SlicingProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    /// ID of slicing profile
    private let slicingProfileID: String

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual slicing profile object
    private let profileProperty = MutableProperty<SlicingProfile?>(nil)

    // MARK: Initializers

    init(slicingProfileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.slicingProfileID = slicingProfileID
        self.provider = provider
        self.contextManager = contextManager

        contextManager.createObservableContext()
            .fetch(SlicingProfile.self, forPrimaryKey: slicingProfileID)
            .startWithResult { result in
                switch result {
                case .success: break
                case .failure: break
                }
            }
    }

    // MARK: Input methods

    // MARK: Output methods

    // MARK: Internal logic
}
