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
class FilesViewController: UICollectionViewController {

    /// Controller view model
    private var viewModel: FilesViewModelType!

    convenience init(viewModel: FilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel

        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.filesListChanged
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputs.viewDidLoad()
    }
}
