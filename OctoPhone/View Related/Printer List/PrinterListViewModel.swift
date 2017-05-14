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

    /// Call when user selected network printer
    ///
    /// - Parameter index: Index of printer
    func selectedNetworkPrinter(at index: Int)

    /// Call when user tapped button for printer addition
    func addPrinterButtonTapped()
}

/// Defines all outputs API for view controller
protocol PrinterListViewModelOutputs {
    /// Total count of stored printers
    var storedPrintersCount: Int { get }

    /// Total count of printers available on network
    var networkPrintersCount: Int { get }

    /// Called when stored printers or network printers changed
    var printersChanged: SignalProducer<(), NoError> { get }

    /// Stream of errors which should be presented to the user
    var displayError: SignalProducer<DisplayableError, NoError> { get }

    /// Creates new ViewModel for local printer cell
    ///
    /// - Parameter index: Cell index in table
    /// - Returns: Cell ViewModel
    func storedPrinterCellViewModel(for index: Int) -> PrinterListCellViewModelType

    /// Creates new ViewModel for network printer cell
    ///
    /// - Parameter index: Cell index in table
    /// - Returns: New ViewModel for network printer cell
    func networkPrinterCellViewModel(for index: Int) -> NetworkPrinterCellViewModelType
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

    var networkPrintersCount: Int { return networkPrintersProperty.value.count }

    let printersChanged: SignalProducer<(), NoError>

    let displayError: SignalProducer<DisplayableError, NoError>

    // MARK: Private properies

    /// Collection of stored printers
    private let storedPrintersProperty = MutableProperty<Results<Printer>?>(nil)

    /// The actual collection of network printers
    private let networkPrintersProperty = MutableProperty<[BonjourService]>([])

    /// Holds last occured error
    private let displayErrorProperty = MutableProperty<DisplayableError?>(nil)

    /// Database context manager
    private let contextManager: ContextManagerType

    /// Controller navigation delegate
    private weak var delegate: PrinterListViewControllerDelegate?

    init(delegate: PrinterListViewControllerDelegate, contextManager: ContextManagerType) {
        self.delegate = delegate
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.producer.skipNil()

        self.printersChanged = SignalProducer.merge([
            networkPrintersProperty.producer.skip(first: 1).ignoreValues(),
            storedPrintersProperty.producer.skipNil().ignoreValues()
        ])

        contextManager.createObservableContext()
            .fetch(collectionOf: Printer.self)
            .startWithResult { [weak self] result in
                switch result {
                case let .success(printers): self?.storedPrintersProperty.value = printers
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.storedPrintersCouldNotBeLoaded))
                }
        }

        Bonjour.searchForServices(ofType: .workstation)
            .observeResult { [weak self] result in
                switch result {
                case let .success(printers):
                    self?.networkPrintersProperty.value = printers
                case .failure:
                    self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                        tr(.networkPrintersCouldNotBeLoaded))
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

    func networkPrinterCellViewModel(for index: Int) -> NetworkPrinterCellViewModelType {
        let service = networkPrintersProperty.value[index]

        return NetworkPrinterCellViewModel(networkPrinter: service)
    }

    // MARK: Inputs

    func selectedStoredPrinter(at indexPath: IndexPath) {
        // At this point, stored printers must not be nil
        assert(storedPrintersProperty.value != nil)

        let printer = storedPrintersProperty.value![indexPath.row]
        let tokenPlugin = TokenPlugin(token: printer.accessToken)
        let provider = OctoPrintProvider(baseURL: printer.url,
                                         plugins: [tokenPlugin])

        delegate?.selectedPrinterProvider(provider: provider, printerID: printer.ID)
    }

    func selectedNetworkPrinter(at index: Int) {
        let service = networkPrintersProperty.value[index]

        delegate?.selectedNetworkPrinter(withService: service)
    }

    func addPrinterButtonTapped() {
        delegate?.addPrinterButtonTapped()
    }
}
