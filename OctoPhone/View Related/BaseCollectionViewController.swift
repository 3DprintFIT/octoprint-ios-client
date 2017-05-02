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

    /// View displayed when detail is not available
    let emptyView: DetailUnavailableView = {
        let view = DetailUnavailableView()

        view.isHidden = true

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = Colors.Views.defaultControllerBackground
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
        view.addSubview(emptyView)

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
