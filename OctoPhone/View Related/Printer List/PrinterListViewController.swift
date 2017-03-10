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
    /// Call when requests provider is selected
    func selectedPrinterProvider(provider: OctoPrintProvider)

    /// Call when add printer button is tapped by user
    func addPrinterButtonTapped()
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

        let dataChangedSignal = Signal.merge([
            viewModel.outputs.networkPrintersChanged,
            viewModel.outputs.storedPrintersChanged
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPrinterButtonTapped)
        )

        if let collectionView = collectionView {
            collectionView.register(
                PrinterListCollectionViewCell.self,
                forCellWithReuseIdentifier: PrinterListCollectionViewCell.identifier
            )

            collectionView.reactive.reloadData <~ dataChangedSignal
        }
    }

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
        case 1: return viewModel.outputs.networkPrintersCount
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PrinterListCollectionViewCell.identifier, for: indexPath
        ) as! PrinterListCollectionViewCell

        cell.viewModel = viewModel.outputs.storedPrinterCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrinterListViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedStoredPrinter(at: indexPath)
    }
}

extension PrinterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
