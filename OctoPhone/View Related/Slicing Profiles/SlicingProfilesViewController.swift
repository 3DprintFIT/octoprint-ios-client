//
//  SlicingProfilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// List of slicing profiles for given slicer
class SlicingProfilesViewController: BaseCollectionViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: SlicingProfilesViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SlicingProfilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(SlicingProfileCollectionViewCell.self,
                                 forCellWithReuseIdentifier: SlicingProfileCollectionViewCell.identifier)
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
extension SlicingProfilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.profilesCount.value
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SlicingProfileCollectionViewCell.identifier,
            for: indexPath) as! SlicingProfileCollectionViewCell

        cell.viewModel.value = viewModel.outputs.slicingProfileCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SlicingProfilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 44)
    }
}