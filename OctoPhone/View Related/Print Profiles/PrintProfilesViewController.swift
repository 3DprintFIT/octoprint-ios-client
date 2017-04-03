//
//  PrintProfilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Print profile list flow delegate
protocol PrintProfilesViewControllerDelegate: class {
    /// Called when user selected printer profile
    ///
    /// - Parameter printerProfile: Selected printer profile
    func selectedPrinterProfile(_ printerProfile: PrinterProfile)
}

/// Printer profiles list
class PrintProfilesViewController: BaseCollectionViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: PrintProfilesViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: PrintProfilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(PrintProfileCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PrintProfileCollectionViewCell.identifier)
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.profilesChanged
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PrintProfilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.profilesCount.value
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PrintProfileCollectionViewCell.identifier,
            for: indexPath) as! PrintProfileCollectionViewCell

        cell.viewModel.value = viewModel.outputs.printProfileCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PrintProfilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedPrinterProfile(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PrintProfilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 44)
    }
}
