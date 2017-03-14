//
//  TerminalCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

/// Terminal flow coordinator
final class TerminalCoordinator: ContextCoordinator {

    /// Printer connection provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = TerminalViewModel(provider: provider, contextManager: contextManager)
        let controller = TerminalViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
