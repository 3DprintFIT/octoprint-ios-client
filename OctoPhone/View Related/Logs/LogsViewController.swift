//
//  LogsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Logs navigation flow delegate
protocol LogsViewControllerDelegate: class {
    /// Called when user selected log to open detail
    ///
    /// - Parameter log: Log selected by user
    func selectedLog(_ log: Log)
}

/// Logs list controller
class LogsViewController: BaseCollectionViewController {

    /// Logs controller logic
    fileprivate var viewModel: LogsViewModelType!

    convenience init(viewModel: LogsViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collectionView = collectionView {
            collectionView.register(LogCollectionViewCell.self,
                                    forCellWithReuseIdentifier: LogCollectionViewCell.identifier)
            collectionView.reactive.reloadData <~ viewModel.outputs.logsListChanged
        }

        reactive.displayableError <~ viewModel.outputs.displayError
    }
}

// MARK: - UICollectionViewDataSource
extension LogsViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.logsCount
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LogCollectionViewCell.identifier,
            for: indexPath) as! LogCollectionViewCell

        cell.viewModel.value = viewModel.outputs.logCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LogsViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedLog(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LogsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 44)
    }
}
