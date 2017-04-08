//
//  BaseCollectionViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Common logic and configuration for all collection view controllers
class BaseCollectionViewController: UICollectionViewController, ErrorPresentable {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
    }
}
