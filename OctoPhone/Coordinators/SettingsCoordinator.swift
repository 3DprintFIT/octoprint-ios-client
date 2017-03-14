//
//  SettingsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Printer settings flow controller
final class SettingsCoordinator: TabCoordinator {
    override func start() {
        let viewModel = SettingsViewModel(delegate: self)
        let controller = SettingsViewController(viewModel: viewModel)

        controller.title = tr(.settings)
        addTab(controller: controller)
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
        let coordinator = LogsCoordinator(navigationController: navigationController)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func slicingCellSelected() {
        let coordinator = SlicingCoordinator(navigationController: navigationController)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func printProfilesCellSelected() {
        let coordinator = PrintProfilesCoordinator(navigationController: navigationController)

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func sdCardManagementCellSelected() {
        let coordinator = SDCardManagementCoordinator(navigationController: navigationController)

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
