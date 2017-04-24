//
//  SDCardManagementCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// SD card management flow coordinator
final class SDCardManagementCoordinator: Coordinator {
    /// Printer requests provider
    private let provider: OctoPrintProvider

    init(navigationController: UINavigationController?, provider: OctoPrintProvider) {
        self.provider = provider

        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = SDCardManagementViewModel(provider: provider)
        let controller = SDCardManagementViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
