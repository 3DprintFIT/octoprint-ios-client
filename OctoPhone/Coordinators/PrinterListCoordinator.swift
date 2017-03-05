//
//  PrinterListCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Controls flow of printer list
final class PrinterListCoordinator: ContextCoordinator {

    override func start() {
        let viewModel = PrinterListViewModel(delegate: self, contextManager: contextManager)
        let controller = PrinterListViewController(viewModel: viewModel)

        controller.title = tr(.printerList)

        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Delegate for printer list controller flow
extension PrinterListCoordinator: PrinterListViewControllerDelegate {
    func selectedPrinterProvider(provider: OctoPrintProvider) {
        let coordinator = OverviewCoordinator(
            navigationController: navigationController,
            contextManager: contextManager,
            provider: provider
        )

        coordinator.completed = { [weak self] in
            self?.childCoordinators.removeLast()
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func addPrinterButtonTapped() {
        let coordinator = PrinterLoginCoordinator(
            navigationController: navigationController,
            contextManager: contextManager
        )

        coordinator.completed = { [weak self] in
            self?.childCoordinators.removeLast()
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
