//
//  SlicingViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Protocol for Slicer list flow delegate
protocol SlicingViewControllerDelegate: class {
    /// Called when user selected specific Slicer
    ///
    /// - Parameter slicer: Slicer selected by user
    func selectedSlicer(_ slicer: Slicer)
}

/// Slicing profiles screen controller
class SlicingViewController: BaseCollectionViewController {

    /// Slicing controller logic
    fileprivate var viewModel: SlicingViewModelType!

    convenience init(viewModel: SlicingViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputs.displayError.startWithValues { error in
            print("\(error.title): \(error.message)")
        }

        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.slicersChanged
            collectionView.register(SlicerCollectionViewCell.self,
                                    forCellWithReuseIdentifier: SlicerCollectionViewCell.identifier)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SlicingViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputs.slicersCount.value
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SlicerCollectionViewCell.identifier,
            for: indexPath) as! SlicerCollectionViewCell

        cell.viewModel.value = viewModel.outputs.slicingCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SlicingViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedSlicer(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SlicingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 44)
    }
}
