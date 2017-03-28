//
//  LogsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

/// Logs list flow coordinator
final class LogsCoordinator: ContextCoordinator {

    /// Printer requests provider
    fileprivate let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = LogsViewModel(delegate: self, provider: provider,
                                      contextManager: contextManager)
        let controller = LogsViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - LogsViewControllerDelegate
extension LogsCoordinator: LogsViewControllerDelegate {
    func selectedLog(_ log: Log) {
        let coordinator = LogDetailCoordinator(
            navigationController: navigationController,
            contextManager: contextManager,
            provider: provider,
            logReference: log.referencePath
        )

        coordinator.completed = { [weak self] in
            self?.childCoordinators.removeLast()
            _ = self?.navigationController?.popViewController(animated: true)
        }

        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
