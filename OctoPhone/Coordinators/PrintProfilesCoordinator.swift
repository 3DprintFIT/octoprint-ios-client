//
//  PrintProfilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Print profiles flow coordinator
final class PrintProfilesCoordinator: Coordinator {
    override func start() {
        let viewModel = PrintProfilesViewModel()
        let controller = PrintProfilesViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}
