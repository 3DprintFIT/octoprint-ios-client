//
//  PrintProfilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import RealmSwift
import ReactiveSwift
import Result

// MARK: - Inputs

/// Print profiles view model outputs
protocol PrintProfilesViewModelInputs {
    /// Call when user selected printer profile
    ///
    /// - Parameter index: Index of selected printer in collection
    func selectedPrinterProfile(at index: Int)

    /// Call when user tapped add profile button
    func addButtonTapped()
}

// MARK: - Outputs

/// Print profiles view model inputs
protocol PrintProfilesViewModelOutputs {
    /// Total count of printer profiles
    var profilesCount: ReactiveSwift.Property<Int> { get }

    /// Stream of profiles changes
    var profilesChanged: SignalProducer<(), NoError> { get }

    /// Stream of errors which should be presented to user
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }

    /// Provides View Model for print profile cell at specific index
    ///
    /// - Parameter index: Index of cell in collection
    /// - Returns: New View Model instance for cell
    func printProfileCellViewModel(for index: Int) -> PrintProfileCellViewModelType
}

// MARK: - Common public interface

/// Common interface for print profiles view model
protocol PrintProfilesViewModelType {
    /// Available inputs
    var inputs: PrintProfilesViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfilesViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Print profiles view controller logic
final class PrintProfilesViewModel: PrintProfilesViewModelType, PrintProfilesViewModelInputs,
PrintProfilesViewModelOutputs {
    var inputs: PrintProfilesViewModelInputs { return self }

    var outputs: PrintProfilesViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let profilesCount: ReactiveSwift.Property<Int>

    var profilesChanged: SignalProducer<(), NoError>

    var displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Delegate
    private weak var delegate: PrintProfilesViewControllerDelegate?

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Collection of printer profiles
    private let profilesProperty = MutableProperty<Results<PrinterProfile>?>(nil)

    /// Last error occured
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(delegate: PrintProfilesViewControllerDelegate, provider: OctoPrintProvider,
         contextManager: ContextManagerType) {

        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager
        self.profilesCount = Property(initial: 0,
                                      then: profilesProperty.producer.skipNil().map({ $0.count }))
        self.profilesChanged = profilesProperty.producer.skipNil().ignoreValues()
        self.displayError = displayErrorProperty.producer.skipNil()

        contextManager.createObservableContext()
            .fetch(collectionOf: PrinterProfile.self)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(profiles): self?.profilesProperty.value = profiles
                case .failure:
                    self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                        tr(.printerProfilesCouldNotBeLoaded))
                }
            }

        requestPrinterProfiles()
    }

    // MARK: Input methods

    func selectedPrinterProfile(at index: Int) {
        assert(profilesProperty.value != nil,
               "Profiles must not be nil when user selected specific profile")

        let profile = profilesProperty.value![index]

        delegate?.selectedPrinterProfile(profile)
    }

    // MARK: Output methods

    func printProfileCellViewModel(for index: Int) -> PrintProfileCellViewModelType {
        assert(profilesProperty.value != nil, "Profiles must not be nil cell view model is requested")

        let profile = profilesProperty.value![index]

        return PrintProfileCellViewModel(printProfileID: profile.ID, contextManager: contextManager)
    }

    func addButtonTapped() {
        delegate?.addButtonTappped()
    }

    // MARK: Internal logic

    /// Request printer profiles list
    private func requestPrinterProfiles() {
        provider.request(.printerProfiles)
            .mapJSON()
            .mapDictionary(collectionOf: PrinterProfile.self, forKeyPath: "profiles")
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(profiles):
                    do {
                        let realm = try weakSelf.contextManager.createContext()

                        try realm.write { realm.add(profiles, update: true) }
                    } catch {
                        weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                               tr(.couldNotSavePrinterProfiles))
                    }
                case .failure:
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.printerProfilesCouldNotBeLoaded))
                }
            }
    }
}
