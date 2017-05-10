//
//  PrinterListViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Printer list flow delegate interface
protocol PrinterListViewControllerDelegate: class {
    /// Called when requests provider is selected
    func selectedPrinterProvider(provider: OctoPrintProvider, printerID: String)

    /// Called when add printer button is tapped by user
    func addPrinterButtonTapped()

    /// Called when user selected network printer to be added
    ///
    /// - Parameter service: Service representing remote printer
    func selectedNetworkPrinter(withService service: BonjourService)
}

/// Represents list of users printers
class PrinterListViewController: BaseCollectionViewController {
    /// Controller view model
    fileprivate var viewModel: PrinterListViewModelType!

    convenience init(viewModel: PrinterListViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPrinterButtonTapped)
        )

        collectionView?.registerTypedCell(cellClass: NetworkPrinterCollectionViewCell.self)
        collectionView?.registerTypedCell(cellClass: PrinterListCollectionViewCell.self)

        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.printersChanged
        }
    }

    /// UI callback for add button tap event
    func addPrinterButtonTapped() {
        viewModel.inputs.addPrinterButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource
extension PrinterListViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // Local printers and user printers
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.outputs.storedPrintersCount
        default: return viewModel.outputs.networkPrintersCount
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Set different ViewModels for network and stored printer
        if indexPath.section == 0 {
            let cell: PrinterListCollectionViewCell = collectionView.dequeueTypedCell(for: indexPath)

            cell.viewModel.value = viewModel.outputs.storedPrinterCellViewModel(for: indexPath.row)
            return cell
        }

        let cell: NetworkPrinterCollectionViewCell = collectionView.dequeueTypedCell(for: indexPath)

        cell.viewModel.value = viewModel.outputs.networkPrinterCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrinterListViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            viewModel.inputs.selectedStoredPrinter(at: indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PrinterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height: CGFloat = indexPath.section == 0 ? 150 : 44

        return CGSize(width: collectionView.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        // Make top insets for all sections but first
        if section > 0 {
            return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }

        return .zero
    }
}
