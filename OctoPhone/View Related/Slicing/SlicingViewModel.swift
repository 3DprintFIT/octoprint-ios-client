//
//  SlicingViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 29/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import RealmSwift
import ReactiveSwift
import Result

// MARK: - Inputs

/// Slicing view model inputs
protocol SlicingViewModelInputs {
    /// Call when user selected Slicer
    ///
    /// - Parameter index: Index of row associated with selected slicer
    func selectedSlicer(at index: Int)
}

// MARK: - Outputs

/// Slicing view model outputs for view controller
protocol SlicingViewModelOutputs {
    /// Screen title
    var title: ReactiveSwift.Property<String> { get }

    /// Total count of slicers installed on printer
    var slicersCount: ReactiveSwift.Property<Int> { get }

    /// Notifies subscriber when list of printers changed
    var slicersChanged: SignalProducer<(), NoError> { get }

    /// Produces errors which should be propagated to the user
    var displayError: SignalProducer<DisplayableError, NoError> { get }

    /// View Model for slicing cell at row index
    ///
    /// - Parameter index: Row index of cell in collection
    func slicingCellViewModel(for index: Int) -> SlicerCellViewModelType
}

// MARK: - Common public interface

/// Common interface for slicing view model
protocol SlicingViewModelType {
    /// Available inputs
    var inputs: SlicingViewModelInputs { get }

    /// Available outputs
    var outputs: SlicingViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Slicing view controller logic
final class SlicingViewModel: SlicingViewModelType, SlicingViewModelInputs, SlicingViewModelOutputs {
    var inputs: SlicingViewModelInputs { return self }

    var outputs: SlicingViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    let title = ReactiveSwift.Property<String>(value: tr(.slicing))

    let slicersCount: ReactiveSwift.Property<Int>

    let slicersChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properties

    /// Slicer list flow delegate
    private weak var delegate: SlicingViewControllerDelegate?

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Database connection manager
    private let contextManager: ContextManagerType

    /// List of slicers installed on printer
    private let slicersProperty = MutableProperty<Results<Slicer>?>(nil)

    /// Holds last occured error
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    // MARK: Initializers

    init(delegate: SlicingViewControllerDelegate, provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager
        self.slicersCount = Property(initial: 0,
                                     then: slicersProperty.producer.skipNil().map({ $0.count }))
        self.displayError = displayErrorProperty.producer.skipNil()
        self.slicersChanged = slicersProperty.producer.ignoreValues()

        contextManager.createObservableContext()
            .fetch(collectionOf: Slicer.self)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(slicers): self?.slicersProperty.value = slicers
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.couldNotLoadListOfSlicers))
                }
            }

        requestSlicers()
    }

    // MARK: Input methods

    func selectedSlicer(at index: Int) {
        assert(slicersProperty.value != nil, "Slicers must not be empty when user selected cell at specific index")

        let slicer = slicersProperty.value![index]

        delegate?.selectedSlicer(slicer)
    }

    // MARK: Output methods

    func slicingCellViewModel(for index: Int) -> SlicerCellViewModelType {
        assert(slicersProperty.value != nil,
               "Slicers list must not be nil while requesting view model for cell")

        return SlicerCellViewModel(slicer: slicersProperty.value![index])
    }

    // MARK: Internal logic

    /// Creates new request for slicer list
    private func requestSlicers() {
        provider.request(.slicers)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapDictionary(collectionOf: Slicer.self)
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(slicers):
                    do {
                        let realm = try weakSelf.contextManager.createContext()
                        try realm.write {
                            realm.add(slicers, update: true)
                        }
                    } catch {
                        weakSelf.displayErrorProperty.value = ("sds", "sds")
                    }
                case let .failure(error):
                    print(error)
                    weakSelf.displayErrorProperty.value = (tr(.anErrorOccured),
                                                           tr(.couldNotLoadListOfSlicers))
                }
            }
    }
}
