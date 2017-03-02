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

    /// Total count of printers found on network
    var networkPrintersCount: Int { get }

    /// Stored printers list changed indicator
    var storedPrintersChanged: Signal<(), NoError> { get }

    var networkPrintersChanged: Signal<(), NoError> { get }

    /// Creates new view model for local printer cell
    ///
    /// - Parameter index: Cell index in table
    /// - Returns: Cell view model
    func storedPrinterCellViewModel(for index: Int) -> PrinterListCellViewModelType
}

/// Defines interface for all printer list view models
protocol PrinterListViewModelType: PrinterListViewModelInputs, PrinterListViewModelOutputs {
    /// Printer list view model inputs
    var inputs: PrinterListViewModelInputs { get }

    /// Printer list view model outputs
    var outputs: PrinterListViewModelOutputs { get }
}

/// View model type for printer list
final class PrinterListViewModel: PrinterListViewModelType {

    var inputs: PrinterListViewModelInputs { return self }

    var outputs: PrinterListViewModelOutputs { return self }

    // MARK: Output properties

    var storedPrintersCount: Int { return storedPrinters?.count ?? 0 }

    var networkPrintersCount: Int { return networkPrintersProperty.value.count }

    let storedPrintersChanged: Signal<(), NoError>

    let networkPrintersChanged: Signal<(), NoError>

    // MARK: Private properies

    /// Collection of stored printers
    private var storedPrinters: Results<Printer>?

    /// Collection of printers found on network - loaded dynamically
    private let networkPrintersProperty = MutableProperty<[Printer]>([])

    /// Realm notification token for stored properties
    private var storedPrintersToken: NotificationToken?

    /// Database context manager
    private let contextManager: ContextManagerType

    private weak var delegate: PrinterListViewControllerDelegate?

    init(delegate: PrinterListViewControllerDelegate, contextManager: ContextManagerType) {
        let (printersSignal, printersObserver) = Signal<(), NoError>.pipe()

        self.delegate = delegate
        self.contextManager = contextManager
        self.storedPrintersChanged = printersSignal
        self.networkPrintersChanged = networkPrintersProperty.signal.map({ _ in })

        do {
            let realm = try contextManager.createContext()

            storedPrinters = realm.objects(Printer.self)

            storedPrintersToken = storedPrinters?.addNotificationBlock({ _ in
                 printersObserver.send(value: ())
            })
        } catch {}
    }

    // MARK: Output functions

    func storedPrinterCellViewModel(for index: Int) -> PrinterListCellViewModelType {
        // Safe to unwrap because view controller asks for index -> count must be greater than 0
        let printer = storedPrinters![index]

        return PrinterListCellViewModel(printer: printer)
    }

    // MARK: Inputs

    func selectedStoredPrinter(at indexPath: IndexPath) {
        // At this point, stored printers must not be nil
        assert(storedPrinters != nil)

        let provider = OctoPrintProvider(baseURL: storedPrinters![indexPath.row].url)

        delegate?.selectedPrinterProvider(provider: provider)
    }

    func addPrinterButtonTapped() {
        delegate?.addPrinterButtonTapped()
    }

    // MARK: Cleanup

    deinit {
        storedPrintersToken?.stop()
    }
}
