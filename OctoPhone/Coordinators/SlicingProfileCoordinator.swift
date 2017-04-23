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

    /// Slicer associated to requested profile
    private let slicerID: String

    /// ID of slicing profile
    private let slicingProfileID: String?

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, slicerID: String, slicingProfileID: String?) {

        self.provider = provider
        self.slicerID = slicerID
        self.slicingProfileID = slicingProfileID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        var viewModel: SlicingProfileViewModelType

        if let slicingProfileID = slicingProfileID {
            viewModel = SlicingProfileViewModel(delegate: self, slicingProfileID: slicingProfileID,
                                                slicerID: slicerID, provider: provider,
                                                contextManager: contextManager)
        } else {
            viewModel = SlicingProfileCreationViewModel(delegate: self, provider: provider,
                                                        slicerID: slicerID)
        }

        let controller = SlicingProfileViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)

        navigationController?.present(navigation, animated: true, completion: nil)
    }
}

extension SlicingProfileCoordinator: SlicingProfileViewControllerDelegate {
    func deletedSlicingProfile() {
        navigationController?.dismiss(animated: true, completion: nil)
        completed()
    }

    func doneButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
        completed()
    }
}
