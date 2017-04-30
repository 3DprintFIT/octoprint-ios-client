//
//  AppCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import UIKit
import Icons

/// Main app flow coordinator
final class AppCoordinator: Coordinator {

    /// App wide database connections manager
    private let contextManager: ContextManagerType

    override init(navigationController: UINavigationController?) {
        self.contextManager = ContextManager()

        super.init(navigationController: navigationController)
    }

    override func start() {
        setupTrackers()

        FontAwesomeIcon.register()

        let coordinator = PrinterListCoordinator(
            navigationController: navigationController,
            contextManager: contextManager
        )

        childCoordinators.append(coordinator)
        coordinator.start()
    }

    /// Setups all trackers and services used in app
    private func setupTrackers() {
        Fabric.with([Crashlytics.self])
    }
}
