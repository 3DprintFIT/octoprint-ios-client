//
//  TerminalCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Terminal flow coordinator
final class TerminalCoordinator: Coordinator {
    override func start() {
        let viewModel = TerminalViewModel()
        let controller = TerminalViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
