//
//  PrintProfileCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 03/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Print profile detail flow coordinator
final class PrintProfileCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    private let printProfileID: String

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, printProfileID: String) {

        self.provider = provider
        self.printProfileID = printProfileID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = PrintProfileViewModel(printProfileID: printProfileID, provider: provider,
                                              contextManager: contextManager)
        let controller = PrintProfileViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
