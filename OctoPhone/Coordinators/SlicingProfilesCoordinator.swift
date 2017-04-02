//
//  SlicingProfilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Coordinates flow of list of specific slicer profiles
final class SlicingProfilesCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// ID of slicer whose profiles will be listed
    private let slicerID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, slicerID: String) {

        self.provider = provider
        self.slicerID = slicerID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = SlicingProfilesViewModel(slicerID: slicerID, provider: provider,
                                                 contextManager: contextManager)
        let controller = SlicingProfilesViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
