//
//  PrinterListCollectionViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/12/2016.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

/// Represents list of users printers
class PrinterListCollcetionViewController: UICollectionViewController {
    /// Data context manager
    private let contextManager: ContextManager

    /// Operation tasks queue
    private let queue = OperationQueue()

    /// List of printers in local network
    fileprivate var localPrinters = [NetService]()

    /// New Printer list controller instance
    /// operating on given context
    ///
    /// - Parameter contextManager: Data context manager
    init(contextManager: ContextManager) {
        self.contextManager = contextManager

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    /// Required initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        fetchData()
    }

    // MARK: UI callbacks

    /// Shows controller with printer addition form
    func showPrinterAdditionController() {
        let navigationController = UINavigationController(
            rootViewController: PrinterLoginViewController(contextManager: contextManager)
        )

        present(navigationController, animated: true, completion: nil)
    }

    /// Configures all view-related properties
    private func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showPrinterAdditionController)
        )

        collectionView?.backgroundColor = .white

        collectionView?.register(
            PrinterOverviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PrinterOverviewCollectionViewCell.identifier
        )
    }

    /// Loads controller data
    private func fetchData() {
        let bonjourOperation = BrowseBonjourOperation()

        bonjourOperation.completionBlock = { [weak self] in
            guard let weakSelf = self else { return }

            weakSelf.localPrinters = bonjourOperation.services.map({ $0 })
            weakSelf.collectionView?.reloadData()
        }

        queue.addOperation(bonjourOperation)
    }
}

// MARK: - UICollectionViewDataSource
extension PrinterListCollcetionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // Local printers and user printers
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return localPrinters.count
        default: return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PrinterOverviewCollectionViewCell.identifier, for: indexPath)

        cell.backgroundColor = .red

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrinterListCollcetionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

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

extension PrinterListCollcetionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
