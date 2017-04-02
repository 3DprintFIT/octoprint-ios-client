//
//  SlicingCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Slicing profiles flow coordinator
final class SlicingCoordinator: ContextCoordinator {

    /// Printer requests provider
    fileprivate let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = SlicingViewModel(delegate: self, provider: provider,
                                         contextManager: contextManager)
        let controller = SlicingViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SlicingViewControllerDelegate
extension SlicingCoordinator: SlicingViewControllerDelegate {
    func selectedSlicer(_ slicer: Slicer) {
        let coordinator = SlicingProfilesCoordinator(navigationController: navigationController,
                                                     contextManager: contextManager,
                                                     provider: provider, slicerID: slicer.ID)

        childCoordinators.append(coordinator)

        coordinator.start()
    }
}
