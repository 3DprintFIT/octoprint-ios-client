//
//  PrinterListViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift
import Result

/// Defines all inputs API for view model
protocol PrinterListViewModelInputs {
    /// Call when user selected stored printer at index path
    ///
    /// - Parameter indexPath: Index path of selected printer
    func selectedStoredPrinter(at indexPath: IndexPath)

    /// Call when user tapped button for printer addition
    func addPrinterButtonTapped()

}

/// Defines all outputs API for view controller
protocol PrinterListViewModelOutputs {
    /// Total count of stored printers
    var storedPrintersCount: Int { get }

    /// Stored printers list changed indicator
    var storedPrintersChanged: SignalProducer<(), NoError> { get }

    /// 
    var displayError: SignalProducer<(title: String, message: String), NoError> { get }

    /// Creates new view model for local printer cell
    ///
    /// - Parameter index: Cell index in table
    /// - Returns: Cell view model
    func storedPrinterCellViewModel(for index: Int) -> PrinterListCellViewModelType
}

/// Defines interface for all printer list view models
protocol PrinterListViewModelType {
    /// Printer list view model inputs
    var inputs: PrinterListViewModelInputs { get }

    /// Printer list view model outputs
    var outputs: PrinterListViewModelOutputs { get }
}

/// View model type for printer list
final class PrinterListViewModel: PrinterListViewModelType, PrinterListViewModelInputs,
PrinterListViewModelOutputs {

    var inputs: PrinterListViewModelInputs { return self }

    var outputs: PrinterListViewModelOutputs { return self }

    // MARK: Output properties

    var storedPrintersCount: Int { return storedPrintersProperty.value?.count ?? 0 }

    let storedPrintersChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<(title: String, message: String), NoError>

    // MARK: Private properies

    /// Collection of stored printers
    private let storedPrintersProperty = MutableProperty<Results<Printer>?>(nil)

    /// Holds last occured error
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    /// Database context manager
    private let contextManager: ContextManagerType

    /// Controller navigation delegate
    private weak var delegate: PrinterListViewControllerDelegate?

    init(delegate: PrinterListViewControllerDelegate, contextManager: ContextManagerType) {
        self.delegate = delegate
        self.contextManager = contextManager
        self.storedPrintersChanged = storedPrintersProperty.producer.ignoreValues()
        self.displayError = displayErrorProperty.producer.skipNil()

        contextManager.createObservableContext()
            .fetch(collectionOf: Printer.self)
            .startWithResult { [weak self] result in

                switch result {
                case let .success(printers): self?.storedPrintersProperty.value = printers
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.storedPrintersCouldNotBeLoaded))
                }
        }
    }

    // MARK: Output functions

    func storedPrinterCellViewModel(for index: Int) -> PrinterListCellViewModelType {
        // If controller asks for specific count, it must be less
        // than printers count, printers are not nil
        assert(storedPrintersProperty.value != nil)

        let printer = storedPrintersProperty.value![index]

        return PrinterListCellViewModel(printer: printer)
    }

    // MARK: Inputs

    func selectedStoredPrinter(at indexPath: IndexPath) {
        // At this point, stored printers must not be nil
        assert(storedPrintersProperty.value != nil)

        let printer = storedPrintersProperty.value![indexPath.row]
        let tokenPlugin = TokenPlugin(token: printer.accessToken)
        let provider = OctoPrintProvider(baseURL: printer.url,
                                         plugins: [tokenPlugin])

        delegate?.selectedPrinterProvider(provider: provider)
    }

    func addPrinterButtonTapped() {
        delegate?.addPrinterButtonTapped()
    }
}
