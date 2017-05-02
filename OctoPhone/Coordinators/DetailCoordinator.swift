//
//  DetailCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Printer detail flow controller
final class DetailCoordinator: TabCoordinator {
    override func start() {
        let viewModel = DetailViewModel(delegate: self, provider: provider)
        let controller = DetailViewController(viewModel: viewModel)

        controller.title = tr(.printerDetail)
        navigationController?.pushViewController(controller, animated: false)
    }
}

// MARK: - DetailViewControllerDelegate
extension DetailCoordinator: DetailViewControllerDelegate {
    func controlsButtonTapped() {
        let coordinator = ControlsCoordinator(navigationController: navigationController,
                                              contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)

        coordinator.start()
    }

    func connectButtonTapped() {
        let coordinator = ConnectPrinterCoordinator(navigationController: navigationController,
                                                    contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)

        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        coordinator.start()
    }
}
