//
//  BedSettingsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Printer detail flow controller
final class BedSettingsCoordinator: ContextCoordinator {

    /// Printer requests provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider) {

        self.provider = provider

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = BedSettingsViewModel(delegate: self)
        let controller = BedSettingsViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)

        navigationController?.present(navigation, animated: true, completion: nil)
    }
}

// MARK: - BedSettingsViewControllerDelegate
extension BedSettingsCoordinator: BedSettingsViewControllerDelegate {
    func doneButtonTapped() {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.completed()
        }
    }
}
