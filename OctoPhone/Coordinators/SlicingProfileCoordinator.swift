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

    /// Slicer associated to requested profile
    private let slicerID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, slicingProfileID: String, slicerID: String) {

        self.provider = provider
        self.slicingProfileID = slicingProfileID
        self.slicerID = slicerID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = SlicingProfileViewModel(delegate: self, slicingProfileID: slicingProfileID,
                                                slicerID: slicerID, provider: provider,
                                                contextManager: contextManager)
        let controller = SlicingProfileViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SlicingProfileCoordinator: SlicingProfileViewControllerDelegate {
    func deletedSlicingProfile() {
        navigationController?.popViewController(animated: true)
        completed()
    }
}
