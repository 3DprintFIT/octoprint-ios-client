//
//  SlicingCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Slicing profiles flow coordinator
final class SlicingCoordinator: Coordinator {
    override func start() {
        let viewModel = SlicingViewModel()
        let controller = SlicingViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
