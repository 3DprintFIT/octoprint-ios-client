//
//  SettingsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Printer settings flow controller
final class SettingsCoordinator: TabCoordinator {
    override func start() {
        let viewModel = SettingsViewModel(delegate: self)
        let controller = SettingsViewController(viewModel: viewModel)

        controller.title = tr(.settings)
        navigationController?.pushViewController(controller, animated: false)
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func terminalCellSelected() {
        let coordinator = TerminalCoordinator(navigationController: navigationController,
                                              contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func logsCellSelected() {
        let coordinator = LogsCoordinator(navigationController: navigationController,
                                          contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func slicingCellSelected() {
        let coordinator = SlicingCoordinator(navigationController: navigationController,
                                             contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func printProfilesCellSelected() {
        let coordinator = PrintProfilesCoordinator(navigationController: navigationController,
                                                   contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func sdCardManagementCellSelected() {
        let coordinator = SDCardManagementCoordinator(navigationController: navigationController,
                                                      provider: provider)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func closePrinterTapped() {
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.completed()
        })
    }
}
