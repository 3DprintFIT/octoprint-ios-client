//
//  SlicingProfileCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controls flow of slicing profile detail
final class SlicingProfileCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// ID of slicing profile
    private let slicingProfileID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, slicingProfileID: String) {

        self.provider = provider
        self.slicingProfileID = slicingProfileID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = SlicingProfileViewModel(slicingProfileID: slicingProfileID,
                                                provider: provider, contextManager: contextManager)
        let controller = SlicingProfileViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
