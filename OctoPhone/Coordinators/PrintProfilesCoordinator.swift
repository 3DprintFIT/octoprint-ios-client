//
//  PrintProfilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Print profiles flow coordinator
final class PrintProfilesCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = PrintProfilesViewModel(provider: provider, contextManager: contextManager)
        let controller = PrintProfilesViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
