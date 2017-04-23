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
    fileprivate let provider: OctoPrintProvider

    /// ID of slicer whose profiles will be listed
    fileprivate let slicerID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, slicerID: String) {

        self.provider = provider
        self.slicerID = slicerID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = SlicingProfilesViewModel(delegate: self, slicerID: slicerID, provider: provider,
                                                 contextManager: contextManager)
        let controller = SlicingProfilesViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SlicingProfilesViewControllerDelegate
extension SlicingProfilesCoordinator: SlicingProfilesViewControllerDelegate {
    func selectedSlicingProfile(_ slicingProfile: SlicingProfile, forSlicer slicer: String) {
        startSlicingProfileCoordinator(slicingProfileID: slicingProfile.ID)
    }

    func addButtonTapped() {
        startSlicingProfileCoordinator(slicingProfileID: nil)
    }

    private func startSlicingProfileCoordinator(slicingProfileID: String?) {
        let coordinator = SlicingProfileCoordinator(navigationController: navigationController,
                                                    contextManager: contextManager, provider: provider,
                                                    slicerID: slicerID,
                                                    slicingProfileID: slicingProfileID)

        childCoordinators.append(coordinator)
        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        coordinator.start()
    }
}
