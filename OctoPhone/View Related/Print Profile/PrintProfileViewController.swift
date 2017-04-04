//
//  PrintProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Print profile detail controller
class PrintProfileViewController: BaseCollectionViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: PrintProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: PrintProfileViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(
            PrintProfileTextInputCollectionViewCell.self,
            forCellWithReuseIdentifier: PrintProfileTextInputCollectionViewCell.identifier)
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {

    }
}

// MARK: - UICollectionViewDataSource
extension PrintProfileViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0: return 2
        case 1: return 0//2
        case 2: return 0//2
        case 3: return 0//3
        case 4: return 0//4
        case 5: return 0//2
        default: fatalError("Unxpected section number")
        }
    }
}
