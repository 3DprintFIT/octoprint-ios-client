//
//  PrintProfileCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Print profile detail flow coordinator
///
/// Handles both profiles editing and creation. Thesese cases
/// are distinguished by initializer. See initializer docs for
/// concrete case.
final class PrintProfileCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Identifier of edited printer profile
    private let printProfileID: String?

    /// Creates flow for profile editing o
    ///
    /// - Parameters:
    ///   - navigationController: Controller, where detail will be pushed
    ///   - contextManager: Database connection manager
    ///   - provider: Printer requests provider
    ///   - printProfileID: Edited profile ID, if left out, new profile will be created
    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, printProfileID: String? = nil) {

        self.provider = provider
        self.printProfileID = printProfileID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel: PrintProfileViewModelType

        if let printProfileID = printProfileID {
            viewModel = PrintProfileViewModel(delegate: self, printProfileID: printProfileID,
                                              provider: provider, contextManager: contextManager)
        } else {
            viewModel = PrintProfileCreationViewModel(delegate: self, provider: provider,
                                                      contextManager: contextManager)
        }

        let controller = UINavigationController(
            rootViewController: PrintProfileViewController(viewModel: viewModel))

        navigationController?.present(controller, animated: true, completion: nil)
    }
}

// MARK: - PrintProfileViewControllerDelegate
extension PrintProfileCoordinator: PrintProfileViewControllerDelegate {
    func doneButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
        completed()
    }

    func closeButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
        completed()
    }
}
