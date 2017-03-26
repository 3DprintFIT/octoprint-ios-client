//
//  LogDetailCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 26/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controls flow of log detail
final class LogDetailCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Identifier of selected log
    private let logID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, logID: String) {

        self.provider = provider
        self.logID = logID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = LogDetailViewModel(logID: logID, provider: provider,
                                           contextManager: contextManager)
        let controller = LogDetailViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
