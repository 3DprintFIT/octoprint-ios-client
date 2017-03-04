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
    /// Network connections provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider
        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = []

        let detailCoordinator = DetailCoordinator(tabbarController: tabbarController,
                                                  navigationController: navigationController,
                                                  contextManager: contextManager,
                                                  provider: provider)
        let filesCoodinator = FilesCoordinator(tabbarController: tabbarController,
                                               navigationController: navigationController,
                                               contextManager: contextManager,
                                               provider: provider)
        let settingsCoordinator = SettingsCoordinator(tabbarController: tabbarController,
                                                      navigationController: navigationController,
                                                      contextManager: contextManager,
                                                      provider: provider)

        childCoordinators.append(detailCoordinator)
        childCoordinators.append(filesCoodinator)
        childCoordinators.append(settingsCoordinator)

        detailCoordinator.start()
        filesCoodinator.start()
        settingsCoordinator.start()

        navigationController?.pushViewController(tabbarController, animated: true)
    }
}
