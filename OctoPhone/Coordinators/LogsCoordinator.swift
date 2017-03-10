//
//  LogsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Logs list flow coordinator
final class LogsCoordinator: Coordinator {
    override func start() {
        let viewModel = LogsViewModel()
        let controller = LogsViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
