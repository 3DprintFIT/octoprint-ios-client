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
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = LogsViewModel(provider: provider, contextManager: contextManager)
        let controller = LogsViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
