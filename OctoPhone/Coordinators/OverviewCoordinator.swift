//
//  OverviewCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controls printer detail flow, keeps all subflows in tabbar controller
final class OverviewCoordinator: ContextCoordinator {
    override func start() {
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = []

        let detailCoordinator = DetailCoordinator(tabbarController: tabbarController,
                                                  navigationController: navigationController,
                                                  contextManager: contextManager)
        let filesCoodinator = FilesCoordinator(tabbarController: tabbarController,
                                               navigationController: navigationController,
                                               contextManager: contextManager)
        let settingsCoordinator = SettingsCoordinator(tabbarController: tabbarController,
                                                      navigationController: navigationController,
                                                      contextManager: contextManager)

        childCoordinators.append(detailCoordinator)
        childCoordinators.append(filesCoodinator)
        childCoordinators.append(settingsCoordinator)

        detailCoordinator.start()
        filesCoodinator.start()
        settingsCoordinator.start()

        navigationController?.pushViewController(tabbarController, animated: true)
    }
}
