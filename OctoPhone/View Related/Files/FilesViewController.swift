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

        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.filesListChanged
        }

        viewModel.outputs.displayError
            .observe(on: UIScheduler())
            .observeValues { title, message in
                let action = UIAlertAction(title: tr(.ok), style: .default, handler: nil)
                let controller = UIAlertController(title: title, message: message,
                                                   preferredStyle: .alert)

                controller.addAction(action)

                self.present(controller, animated: true, completion: nil)
            }

        collectionView?.register(FileCollectionViewCell.self,
                                 forCellWithReuseIdentifier: FileCollectionViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWilAppear()
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

        cell.viewModel = viewModel.outputs.fileCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDataSource

extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
