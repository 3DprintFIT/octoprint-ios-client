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

    /// Call when user tapped on done button
    func doneButtonTapped()

    /// Call when user tapped cancel button
    func cancelButtonTapped()

    /// Call when user changed the name of slicing profile
    ///
    /// - Parameter newValue: New name
    func nameChanged(_ newValue: String?)

    /// Call when user changed the description of slicing profile
    ///
    /// - Parameter newValue: New description
    func descriptionChanged(_ newValue: String?)
}

// MARK: - Outputs

/// Slicing profile detail outputs for Controller
protocol SlicingProfileViewModelOutputs {
    /// Screen title
    var title: Property<String> { get }

    /// Indicates whether the delete button should be visible to the user
    var deleteButtonIsVisible: Property<Bool> { get }

    /// Indicates whether the content is editable or not
    var contentIsEditable: Property<Bool> { get }

    /// Text for name label
    var nameText: Property<String> { get }

    /// Actual profile name
    var profileName: Property<String> { get }

    /// Text for description label
    var descriptionText: Property<String> { get }

    /// Actual profile description
    var profileDescription: Property<String> { get }

    /// Stream of errors which should be presented to the user
    var displayError: SignalProducer<DisplayableError, NoError> { get }
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

    let title: Property<String>

    let deleteButtonIsVisible = Property<Bool>(value: true)

    let contentIsEditable = Property<Bool>(value: false)

    let nameText = Property<String>(value: tr(.slicingProfileReference))

    let profileName: Property<String>

    let descriptionText = Property<String>(value: tr(.slicingProfileDescription))

    let profileDescription: Property<String>

    let displayError: SignalProducer<DisplayableError, NoError>

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
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    // MARK: Initializers

    init(delegate: SlicingProfileViewControllerDelegate, slicingProfileID: String, slicerID: String,
         provider: OctoPrintProvider, contextManager: ContextManagerType) {

        self.delegate = delegate
        self.slicingProfileID = slicingProfileID
        self.slicerID = slicerID
        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.producer.skipNil()
        self.title = Property(initial: tr(.slicerProfile),
                              then: profileProperty.producer.map({ $0?.name }).skipNil())

        let profileProducer = profileProperty.producer.skipNil()

        self.profileName = Property(initial: tr(.unknown), then: profileProducer.map({ $0.name }).skipNil())
        self.profileDescription = Property(initial: tr(.unknown),
                                           then: profileProducer.map ({ $0.profileDescription }).skipNil())

        loadSlicingProfile()
    }

    // MARK: Input methods

    func deleteProfile() {
        deleteSlicingProfile()
    }

    func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }

    func cancelButtonTapped() {
        delegate?.doneButtonTapped()
    }

    func nameChanged(_ newValue: String?) {
        // Profile update not implemented
    }

    func descriptionChanged(_ newValue: String?) {
        // Profile update not implemented
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

    private func loadSlicingProfile() {
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
}
