//
//  SettingsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/12/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

/// Common interface for navigation from settings
protocol SettingsViewControllerDelegate: class {
    /// Called when termianl cell was selected
    func terminalCellSelected()

    /// Called when logs list cell was selected
    func logsCellSelected()

    /// Called when slicing profiles cell was selected
    func slicingCellSelected()

    /// Called when print profiles cell was selected
    func printProfilesCellSelected()

    /// Celled when sd card management cell was selected
    func sdCardManagementCellSelected()

    /// Called when user decided to close printer detail
    func closePrinterTapped()
}

/// Printer settings and configurations
class SettingsViewController: BaseCollectionViewController {

    /// Settings logic
    fileprivate var viewModel: SettingsViewModelType!

    convenience init(viewModel: SettingsViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(SettingsCollectionViewCell.self,
                                 forCellWithReuseIdentifier: SettingsCollectionViewCell.identifier)
        collectionView?.register(ClosePrinterCellCollectionViewCell.self,
                                 forCellWithReuseIdentifier: ClosePrinterCellCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource
extension SettingsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return 6
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var commonCell: UICollectionViewCell

        if indexPath.row < 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                SettingsCollectionViewCell.identifier, for: indexPath) as! SettingsCollectionViewCell

            switch indexPath.row {
            case 0: cell.viewModel.value = viewModel.outputs.terminalCellViewModel()
            case 1: cell.viewModel.value = viewModel.outputs.logsCellViewModel()
            case 2: cell.viewModel.value = viewModel.outputs.slicingCellViewModel()
            case 3: cell.viewModel.value = viewModel.outputs.printProfilesCellViewModel()
            case 4: cell.viewModel.value = viewModel.outputs.sdCardManagementCellViewModel()
            default: break
            }

            commonCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                ClosePrinterCellCollectionViewCell.identifier, for: indexPath
                ) as! ClosePrinterCellCollectionViewCell

            cell.viewModel.value = viewModel.outputs.closePrinterCellViewModel()
            cell.viewModel.value?.outputs.closePrinterTapped.startWithValues({ [weak self] in
                self?.viewModel.inputs.closePrinterTapped()
            })

            commonCell = cell
        }

        return commonCell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0: viewModel.inputs.terminalCellSelected()
        case 1: viewModel.inputs.logsCellSelected()
        case 2: viewModel.inputs.slicingCellSelected()
        case 3: viewModel.inputs.printProfilesCellSelected()
        case 4: viewModel.inputs.sdCardManagementCellSelected()
        default: break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0.5
    }
}
