//
//  PrintProfilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Print profiles flow coordinator
final class PrintProfilesCoordinator: ContextCoordinator {

    /// Printer requests provider
    fileprivate let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = PrintProfilesViewModel(delegate: self, provider: provider,
                                               contextManager: contextManager)
        let controller = PrintProfilesViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PrintProfilesCoordinator: PrintProfilesViewControllerDelegate {
    func selectedPrinterProfile(_ printerProfile: PrinterProfile) {
        let coordinator = PrintProfileCoordinator(navigationController: navigationController,
                                                  contextManager: contextManager, provider: provider,
                                                  printProfileID: printerProfile.ID)

        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func addButtonTappped() {
        let coordinator = PrintProfileCoordinator(navigationController: navigationController,
                                                  contextManager: contextManager, provider: provider)

        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
