//
//  ConnectPrinterCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Controls flow of printer head controls screen
final class ConnectPrinterCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = ConnectPrinterViewModel(delegate: self, provider: provider)
        let controller = ConnectPrinterViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)

        navigationController?.present(navigation, animated: true, completion: nil)
    }
}

// MARK: - ConnectPrinterViewControllerDelegate
extension ConnectPrinterCoordinator: ConnectPrinterViewControllerDelegate {
    func closeButtonTapped() {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.completed()
        }
    }
}
