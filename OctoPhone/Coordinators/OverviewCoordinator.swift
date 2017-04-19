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
        let detailNavigationController = UINavigationController()
        let filesNavigationController = UINavigationController()
        let settingsNavigationController = UINavigationController()

        tabbarController.viewControllers = [detailNavigationController,
                                            filesNavigationController, settingsNavigationController]
        tabbarController.view.backgroundColor = .white

        let detailCoordinator = DetailCoordinator(tabbarController: tabbarController,
                                                  navigationController: detailNavigationController,
                                                  contextManager: contextManager,
                                                  provider: provider)
        let filesCoodinator = FilesCoordinator(tabbarController: tabbarController,
                                               navigationController: filesNavigationController,
                                               contextManager: contextManager,
                                               provider: provider)
        let settingsCoordinator = SettingsCoordinator(tabbarController: tabbarController,
                                                      navigationController: settingsNavigationController,
                                                      contextManager: contextManager,
                                                      provider: provider)

        childCoordinators.append(detailCoordinator)
        childCoordinators.append(filesCoodinator)
        childCoordinators.append(settingsCoordinator)

        settingsCoordinator.completed = { [weak self] in
            self?.childCoordinators.removeAll()
            self?.navigationController?.dismiss(animated: true, completion: {
                self?.completed()
            })
        }

        detailCoordinator.start()
        filesCoodinator.start()
        settingsCoordinator.start()

        navigationController?.present(tabbarController, animated: true, completion: nil)
    }
}
