//
//  SlicingProfileCreationViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 22/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - View Model implementation

/// Logic for slicing profile creation screen
final class SlicingProfileCreationViewModel: SlicingProfileViewModelType, SlicingProfileViewModelInputs,
SlicingProfileViewModelOutputs {
    var inputs: SlicingProfileViewModelInputs { return self }

    var outputs: SlicingProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = Property<String>(value: tr(.addNewSlicingProfile))

    let deleteButtonIsVisible = Property<Bool>(value: false)

    let contentIsEditable = Property<Bool>(value: true)

    let nameText = Property<String>(value: tr(.slicingProfileName))

    let profileName = Property<String>(value: "")

    let descriptionText = Property<String>(value: tr(.slicingProfileDescription))

    let profileDescription = Property<String>(value: "")

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Slicing profile flow delegate
    private weak var delegate: SlicingProfileViewControllerDelegate?

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// ID of current slicer
    private let slicerID: String

    /// Current value of profile name
    private let nameProperty = MutableProperty<String?>(nil)

    /// Current value of profile description
    private let descriptionProperty = MutableProperty<String?>(nil)

    /// Holds last occured error
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    // MARK: Initializers

    init(delegate: SlicingProfileViewControllerDelegate, provider: OctoPrintProvider, slicerID: String) {
        self.delegate = delegate
        self.provider = provider
        self.slicerID = slicerID
        self.displayError = displayErrorProperty.producer.skipNil()
    }

    // MARK: Input methods

    func deleteProfile() {
        fatalError("Profile deletion is only possible while editing profile not while creating one.")
    }

    func doneButtonTapped() {
        guard
            let name = nameProperty.value,
            let description = descriptionProperty.value,
            !name.isEmpty,
            !description.isEmpty else
        {
            displayErrorProperty.value = (tr(.anErrorOccured), tr(.slicingProfileFieldsAreRequired))
            return
        }

        createSlicerProfile(name: name, description: description)
    }

    func cancelButtonTapped() {
        delegate?.doneButtonTapped()
    }

    func nameChanged(_ newValue: String?) {
        nameProperty.value = newValue
    }

    func descriptionChanged(_ newValue: String?) {
        descriptionProperty.value = newValue
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Creates new profile on printer for current slicer
    private func createSlicerProfile(name: String, description: String) {
        provider.request(.createSlicerProfile(slicerID: slicerID, name: name, description: description))
            .filterSuccessfulStatusCodes()
            .observe(on: UIScheduler())
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case .success:
                    weakSelf.delegate?.doneButtonTapped()
                case .failure: weakSelf.displayErrorProperty.value =
                    (tr(.anErrorOccured), tr(.slicingProfileCouldNotBeCreated))
                }
            }
    }
}
