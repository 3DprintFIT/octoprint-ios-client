//
//  SlicingProfilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import RealmSwift
import Result

// MARK: - Inputs

/// Inputs for View Model logic
protocol SlicingProfilesViewModelInputs {
    /// Call when user selected slicing profile at specific index
    ///
    /// - Parameter index: Index of selected row
    func selectedProfile(at index: Int)
}

// MARK: - Outputs

/// Outputs from View Model logic
protocol SlicingProfilesViewModelOutputs {
    /// Total count of stored slicing profiles
    var profilesCount: ReactiveSwift.Property<Int> { get }

    /// Stream of profiles change
    var profilesChanged: SignalProducer<(), NoError> { get }

    /// Stream of occured errors which should be presented to the user
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }

    /// View model for slicing profile cell at given index
    ///
    /// - Parameter index: New VM instance for collection cell
    func slicingProfileCellViewModel(for index: Int) -> SlicingProfileCellViewModel
}

// MARK: - Common public interface

/// Common protocol for slicer profiles View Model
protocol SlicingProfilesViewModelType {
    /// Available inputs
    var inputs: SlicingProfilesViewModelInputs { get }

    /// Available outputs
    var outputs: SlicingProfilesViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Internal logic for slicing profiles View Controller
final class SlicingProfilesViewModel: SlicingProfilesViewModelType, SlicingProfilesViewModelInputs,
SlicingProfilesViewModelOutputs {
    var inputs: SlicingProfilesViewModelInputs { return self }

    var outputs: SlicingProfilesViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let profilesCount: ReactiveSwift.Property<Int>

    let profilesChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// ID of slicer whose profiles are displayed
    private let slicerID: String

    /// Slicing profile controller flow delegate
    private weak var delegate: SlicingProfilesViewControllerDelegate?

    /// Printer request provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Slicer settings profiles
    private let profilesProperty = MutableProperty<List<SlicingProfile>?>(nil)

    /// Last error occured
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(delegate: SlicingProfilesViewControllerDelegate, slicerID: String,
         provider: OctoPrintProvider, contextManager: ContextManagerType) {

        self.delegate = delegate
        self.slicerID = slicerID
        self.provider = provider
        self.contextManager = contextManager
        self.profilesCount = Property(initial: 0,
                                      then: profilesProperty.producer.skipNil().map({ $0.count }))
        self.profilesChanged = profilesProperty.producer.ignoreValues()
        self.displayError = displayErrorProperty.producer.skipNil()

        contextManager.createObservableContext()
            .fetch(Slicer.self, forPrimaryKey: slicerID)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(slicer):
                    guard let slicer = slicer else {
                        // The screen should be closed as nothing is loaded
                        return
                    }

                    self?.profilesProperty.value = slicer.slicingProfiles
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.slicerProfilesCouldNotBeLoaded))
                }
            }

        requestSlicerProfiles()
    }

    // MARK: Input methods

    func selectedProfile(at index: Int) {
        assert(profilesProperty.value != nil,
               "Slicing profiles must not be nil when use selected profile at specifi index")

        let profile = profilesProperty.value![index]

        delegate?.selectedSlicingProfile(profile, forSlicer: slicerID)
    }

    // MARK: Output methods

    func slicingProfileCellViewModel(for index: Int) -> SlicingProfileCellViewModel {
        assert(profilesProperty.value != nil,
               "Slicing profiles must not be nil when cell VM is required")

        let profile = profilesProperty.value![index]

        return SlicingProfileCellViewModel(profileID: profile.ID, contextManager: contextManager)
    }

    // MARK: Internal logic

    /// Request slicer profiles from printer
    private func requestSlicerProfiles() {
        provider.request(.slicerProfiles(slicerID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapDictionary(collectionOf: SlicingProfile.self)
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(profiles):
                    do {
                        let realm = try weakSelf.contextManager.createContext()

                        try realm.write {
                            realm.add(profiles, update: true)
                        }
                    } catch {
                        weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                               tr(.slicerProfilesCouldNotBeLoaded))
                    }
                case .failure:
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.downloadedListOfSlicingProfilesCouldNotBeSaved))
                }
            }
    }
}
