//
//  DetailCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import Icons

/// Printer detail flow controller
final class DetailCoordinator: TabCoordinator {

    /// Identifier of printer to be opened
    private let printerID: String

    init(tabbarController: UITabBarController?, navigationController: UINavigationController?,
         contextManager: ContextManagerType, provider: OctoPrintProvider, printerID: String) {

        self.printerID = printerID

        super.init(tabbarController: tabbarController, navigationController: navigationController,
                   contextManager: contextManager, provider: provider)
    }

    override func start() {
        let viewModel = DetailViewModel(delegate: self, provider: provider,
                                        contextManager: contextManager, printerID: printerID)
        let controller = DetailViewController(viewModel: viewModel)

        controller.title = tr(.printerDetail)
        controller.tabBarItem = UITabBarItem(withIcon: .ulIcon, size: CGSize(width: 22, height: 22),
                                             title: tr(.printerDetail))
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

    func bedCellTapped() {
        let coordinator = BedSettingsCoordinator(navigationController: navigationController,
                                                 contextManager: contextManager, provider: provider)

        childCoordinators.append(coordinator)

        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        coordinator.start()
    }
}
