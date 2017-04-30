//
//  ControlsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controls flow of printer head controls screen
final class ControlsCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = ControlsViewModel()

        let controller = ControlsViewController(viewModel: viewModel)
//        let navigation = UINavigationController(rootViewController: controller)

        navigationController?.pushViewController(controller, animated: true)
    }
}
