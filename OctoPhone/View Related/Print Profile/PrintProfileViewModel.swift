//
//  PrintProfileViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Moya
import ReactiveSwift
import Result

// MARK: - Inputs

/// Print profile detail inputs
protocol PrintProfileViewModelInputs {
    /// Call when user changed profile name
    ///
    /// - Parameter newValue: New profile name
    func profileNameChanged(_ newValue: String?)

    /// Call when user changed profile identifier
    ///
    /// - Parameter newValue: New profile identifier
    func profileIdentifierChanged(_ newValue: String?)

    /// Call when user changed printer model
    ///
    /// - Parameter newValue: New printer model
    func profileModelChanged(_ newValue: String?)
}

// MARK: - Outputs

/// Print profile logic output
protocol PrintProfileViewModelOutputs {
    /// Profile name input description
    var profileNameDescription: Property<String> { get }

    /// Profile name default value
    var profileNameValue: Property<String?> { get }

    /// Profile identifier input description
    var profileIdentifierDescription: Property<String> { get }

    /// Profile identifier default value
    var profileIdentifierValue: Property<String?> { get }

    /// Indicates whether profile identifier is editable
    var profileIdentifierIsEditable: Property<Bool> { get }

    /// Profile model input descripiton
    var profileModelDescription: Property<String> { get }

    /// Profile model default value
    var profileModelValue: Property<String?> { get }
}

// MARK: - Common public interface

/// Common protocol for print profile logic
protocol PrintProfileViewModelType {
    /// Available inputs
    var inputs: PrintProfileViewModelInputs { get }

    /// Available outputs
    var outputs: PrintProfileViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Print profile detail logic
///
/// When the profile is updated, the local file is loaded to the form,
/// then it waits for user inputs. When user change whichever form field,
/// the profile is updated on the printer.
final class PrintProfileViewModel: PrintProfileViewModelType, PrintProfileViewModelInputs,
PrintProfileViewModelOutputs {
    var inputs: PrintProfileViewModelInputs { return self }

    var outputs: PrintProfileViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let profileNameDescription = Property<String>(value: tr(.printProfileName))

    let profileNameValue: Property<String?>

    let profileIdentifierDescription = Property<String>(value: tr(.printProfileIdentifier))

    let profileIdentifierValue: Property<String?>

    let profileIdentifierIsEditable = Property(value: false)

    let profileModelDescription = Property<String>(value: tr(.printProfileModel))

    let profileModelValue: Property<String?>

    // MARK: Private properties

    /// identifier of print profile
    private let printProfileID: String

    /// Printer request provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// Actual printer profile
    private let printProfileProperty = MutableProperty<PrinterProfile?>(nil)

    /// User defined profile name
    private let profileNameProperty = MutableProperty<String?>(nil)

    /// User defined profile identifier
    private let profileIdentifierProperty = MutableProperty<String?>(nil)

    /// User defined printer model name
    private let profileModelProperty = MutableProperty<String?>(nil)

    /// Takes care of signal dispose
    private let compositeDisposable = CompositeDisposable()

    // MARK: Initializers

    init(printProfileID: String, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.printProfileID = printProfileID
        self.provider = provider
        self.contextManager = contextManager

        let profileProducer = printProfileProperty.producer.skipNil().take(first: 1)

        self.profileNameValue = Property(initial: nil,
                                         then: profileProducer.map({ $0.name }))
        self.profileIdentifierValue = Property(initial: nil,
                                               then: profileProducer.map({ $0.ID }))
        self.profileModelValue = Property(initial: nil,
                                          then: profileProducer.map({ $0.model }))

        contextManager.createObservableContext()
            .fetch(PrinterProfile.self, forPrimaryKey: printProfileID)
            .skipError()
            .startWithValues { [weak self] profile in
                self?.printProfileProperty.value = profile
            }

        // Set initial values for user inputs
        printProfileProperty.producer.skipNil().take(first: 1)
            .startWithValues { [weak self] profile in
                self?.profileNameProperty.value = profile.name
                self?.profileIdentifierProperty.value = profile.ID
                self?.profileModelProperty.value = profile.model
            }

        watchFormChanges()
        setupProfileSync()
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

    // MARK: Output methods

    // MARK: Internal logic

    /// Watches for changes in form and saves them into database
    private func watchFormChanges() {
        SignalProducer.combineLatest(profileNameProperty.producer.skipNil(),
                                     profileIdentifierProperty.producer.skipNil(),
                                     profileModelProperty.producer.skipNil())
            // Skip the initial values
            .skip(first: 1)
            .debounce(0.8, on: QueueScheduler.main)
            .startWithValues { [weak self] name, _, model in
                guard let profile = self?.printProfileProperty.value else { return }

                try? profile.realm?.write {
                    profile.name = name
                    profile.model = model
                }
            }
    }

    /// Once called, starts to sync local profile changes to printer
    private func setupProfileSync() {
        printProfileProperty.producer
            .skipNil()
            // Skip nil and initial state
            .skip(first: 1)
            .logEvents()
            .flatMap(.latest) { (profile: PrinterProfile) in
                return self.provider.request(.updatePrinterProfile(profileID: self.printProfileID,
                                                                   data: ["profile": profile.asJSON()]))
            }.startWithFailed { error in
                print(error)
            }
    }
}
