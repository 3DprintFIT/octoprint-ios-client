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
    func selectedPrinterPrinterProvider()

    /// Call when add printer button is tapped by user
    func addPrinterButtonTapped()
}

/// Represents list of users printers
class PrinterListViewController: UICollectionViewController {

    /// Flow delegate
    weak var delegate: PrinterListViewControllerDelegate?

    ///
    fileprivate let viewModel: PrinterListViewModelType

    init(viewModel: PrinterListViewModelType) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    /// Required initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            collectionView.backgroundColor = .white
            collectionView.register(
                PrinterOverviewCollectionViewCell.self,
                forCellWithReuseIdentifier: PrinterOverviewCollectionViewCell.identifier
            )

            collectionView.reactive.reloadData <~ dataChangedSignal
        }
    }

    func addPrinterButtonTapped() {
        delegate?.addPrinterButtonTapped()
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
            withReuseIdentifier: PrinterOverviewCollectionViewCell.identifier, for: indexPath
        ) as! PrinterOverviewCollectionViewCell

        cell.viewModel = viewModel.outputs.storedPrinterCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrinterListViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        delegate?.selectedPrinterPrinterProvider()

        let tabbarController = UITabBarController()
        let printerOverviewController = PrinterOverviewViewController()
        let filesController = FilesViewController()
        let printerSettingsController = PrinterSettingsViewController()

        printerOverviewController.title = tr(.printer)
        filesController.title = tr(.files)
        printerSettingsController.title = tr(.settings)

        tabbarController.viewControllers = [printerOverviewController, filesController,
                                            printerSettingsController]
        tabbarController.view.backgroundColor = .white

        navigationController?.pushViewController(tabbarController, animated: true)
    }
}

extension PrinterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
