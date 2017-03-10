//
//  SDCardManagementCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// SD card management flow coordinator
final class SDCardManagementCoordinator: Coordinator {
    override func start() {
        let viewModel = SDCardManagementViewModel()
        let controller = SDCardManagementViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
