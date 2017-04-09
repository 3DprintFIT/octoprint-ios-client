//
//  FilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/12/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// File list flow delegate
protocol FilesViewControllerDelegate: class {
    /// Called when user selected file to expand detail
    ///
    /// - Parameter file: File to be expanded
    func selectedFile(_ file: File)
}

/// Lists stored files on printer
class FilesViewController: BaseCollectionViewController {

    /// Controller view model
    fileprivate var viewModel: FilesViewModelType!

    convenience init(viewModel: FilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()

        collectionView?.register(FileCollectionViewCell.self,
                                 forCellWithReuseIdentifier: FileCollectionViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWilAppear()
    }

    // MARK: Internal logic

    /// Binds View Model to the UI elements
    private func bindViewModel() {
        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.filesListChanged
        }

        viewModel.outputs.displayError
            .observe(on: UIScheduler())
            .observeValues { [weak self] title, message in
                self?.presentError(title: title, message: message)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.filesCount
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FileCollectionViewCell.identifier,
            for: indexPath
        ) as! FileCollectionViewCell

        cell.viewModel.value = viewModel.outputs.fileCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 44)
    }
}

// MARK: - UICollectionViewDelegate
extension FilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedFile(at: indexPath.row)
    }
}
