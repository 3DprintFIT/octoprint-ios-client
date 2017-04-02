//
//  SlicingProfileViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Slicing profile detail inputs from Controller
protocol SlicingProfileViewModelInputs {
    /// Call when user requested profile deletion
    func deleteProfile()
}

// MARK: - Outputs

/// Slicing profile detail outputs for Controller
protocol SlicingProfileViewModelOutputs {
    /// Stream of errors which should be presented to the user
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }
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

     let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Delegate of detail controller
    private weak var delegate: SlicingProfileViewControllerDelegate?

    /// ID of slicing profile
    private let slicingProfileID: String

    /// ID of associated slicer
    private let slicerID: String

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual slicing profile object
    private let profileProperty = MutableProperty<SlicingProfile?>(nil)

    /// Holds lates occured error
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(delegate: SlicingProfileViewControllerDelegate, slicingProfileID: String, slicerID: String,
         provider: OctoPrintProvider, contextManager: ContextManagerType) {

        self.delegate = delegate
        self.slicingProfileID = slicingProfileID
        self.slicerID = slicerID
        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.producer.skipNil()

        contextManager.createObservableContext()
            .fetch(SlicingProfile.self, forPrimaryKey: slicingProfileID)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(profile): self?.profileProperty.value = profile
                case .failure:
                    self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                        tr(.selectedProfileCouldNotBeOpened))
                }
            }
    }

    // MARK: Input methods

    func deleteProfile() {
        deleteSlicingProfile()
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Delete current slicing profile and finish flow if it's deleted successfully
    private func deleteSlicingProfile() {
        provider.request(.deleteSlicingProfile(slicerID: slicerID, profileID: slicingProfileID))
            .filterSuccessfulStatusCodes()
            .startWithResult { [weak self] result in
                guard
                    let weakSelf = self,
                    let profile = weakSelf.profileProperty.value,
                    let realm = profile.realm else { return }

                switch result {
                case .success:
                    do {
                        try realm.write {
                            realm.delete(profile)
                        }

                        weakSelf.delegate?.deletedSlicingProfile()
                    } catch {
                        weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                               tr(.slicingProfileCouldNotBeDeleted))
                    }
                case .failure:
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.slicingProfileCouldNotBeDeleted))
                }
        }
    }
}
