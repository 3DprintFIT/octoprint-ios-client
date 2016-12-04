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

    /// New Printer list controller instance
    /// operating on given context
    ///
    /// - Parameter contextManager: Data context manager
    init(contextManager: ContextManager) {
        self.contextManager = contextManager

        super.init(nibName: nil, bundle: nil)
    }

    /// Required initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    /// Configures all view-related properties
    private func configureView() {
        collectionView?.register(
            PrinterOverviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PrinterOverviewCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource
extension PrinterListCollcetionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // Local printers and user printers
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PrinterOverviewCollectionViewCell.identifier,
            for: indexPath
        )

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrinterListCollcetionViewController {

}
