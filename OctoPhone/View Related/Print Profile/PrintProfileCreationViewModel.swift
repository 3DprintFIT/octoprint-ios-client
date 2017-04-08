//
//  PrintProfileCreationViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 08/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - View Model implementation

/// Printer profile creation logic, uses same protocol as editing View Model
/// so can be used with the very same View Controller.
///
/// Profile is saved by explicit user action.
final class PrintProfileCreationViewModel: PrintProfileViewModelType, PrintProfileViewModelInputs,
PrintProfileViewModelOutputs {
    var inputs: PrintProfileViewModelInputs { return self }

    var outputs: PrintProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let profileNameDescription = Property<String>(value: tr(.printProfileName))

    let profileNameValue = Property<String?>(value: nil)

    let profileIdentifierDescription = Property<String>(value: tr(.printProfileIdentifier))

    let profileIdentifierValue = Property<String?>(value: nil)

    let profileIdentifierIsEditable = Property(value: true)

    let profileModelDescription = Property<String>(value: tr(.printProfileModel))

    let profileModelValue = Property<String?>(value: nil)

    let closeButtonIsHidden = Property<Bool>(value: false)

    let doneButtonIsEnabled: Property<Bool>

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properties

    /// Controller flow delegate
    private weak var delegate: PrintProfileViewControllerDelegate?

    /// Printer request provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// User defined profile name
    private let profileNameProperty = MutableProperty<String?>(nil)

    /// User defined profile identifier
    private let profileIdentifierProperty = MutableProperty<String?>(nil)

    /// User defined printer model name
    private let profileModelProperty = MutableProperty<String?>(nil)

    /// Tracks user taps on done button
    private let doneButtonPressedProperty = MutableProperty<()>(())

    /// Represents all editable form fields values
    private let formValuesProducer: SignalProducer<(String, String, String), NoError>

    /// Last occured error
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    // MARK: Initializers

    init(delegate: PrintProfileViewControllerDelegate, provider: OctoPrintProvider,
         contextManager: ContextManagerType) {

        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager
        self.formValuesProducer = SignalProducer.combineLatest(profileNameProperty.producer.skipNil(),
                                                               profileIdentifierProperty.producer.skipNil(),
                                                               profileModelProperty.producer.skipNil())

        let formValidProducer = formValuesProducer
            .map { name, identifier, model in
                return !name.isEmpty && !identifier.isEmpty && !model.isEmpty
            }

        self.doneButtonIsEnabled = Property(initial: false, then: formValidProducer)
        self.displayError = displayErrorProperty.producer.skipNil()

        trackProfileSavingEvent()
    }

    // MARK: Input methods

    func profileNameChanged(_ newValue: String?) {
        profileNameProperty.value = newValue
    }

    func profileIdentifierChanged(_ newValue: String?) {
        profileIdentifierProperty.value = newValue
    }

    func profileModelChanged(_ newValue: String?) {
        profileModelProperty.value = newValue
    }

    func doneButtonTapped() {
        doneButtonPressedProperty.value = ()
    }

    func closeButtonTapped() {
        delegate?.closeButtonTapped()
    }

    func deleteButtonTapped() {
        fatalError("Profile deletion is not support when creating new profile.")
    }

    // MARK: Output methods

    // MARK: Internal logic

    /// Once called, tracks save events and creates profile on printer
    private func trackProfileSavingEvent() {
        let saveEvent = doneButtonPressedProperty.producer.skip(first: 1)

        let createProfileEvent = formValuesProducer
            .sample(on: saveEvent)
            .map { return PrinterProfile(ID: $1, model: $2, name: $0) }
            .flatMap(.latest) { profile in
                self.provider.request(.createPrinterProfile(data: ["profile": profile.asJSON()]))
                    .filterSuccessfulStatusCodes()
                    .mapJSON()
                    .mapDictionary(collectionOf: PrinterProfile.self)
                    .materialize()
            }
            .observe(on: UIScheduler())

        createProfileEvent.map { $0.value }.skipNil().startWithValues { [weak self] profile in
            guard let weakSelf = self else { return }

            do {
                let realm = try weakSelf.contextManager.createContext()
                try realm.write {
                    realm.add(profile, update: true)
                }

                weakSelf.delegate!.doneButtonTapped()
            } catch {
                weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                       tr(.createdProfileCouldNotBeSavedLocaly))
            }
        }

        createProfileEvent.map { $0.error }.skipNil().startWithValues { [weak self] _ in
            self?.displayErrorProperty.value = (tr(.anErrorOccured), tr(.profileCouldNotBeCreated))
        }
    }
}
