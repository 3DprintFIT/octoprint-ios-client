//
//  FilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit
import Icons

/// Stored files list coordinator
final class FilesCoordinator: TabCoordinator {
    override func start() {
        let viewModel = FilesViewModel(delegate: self, provider: provider, contextManager: contextManager)
        let controller = FilesViewController(viewModel: viewModel)

        controller.title = tr(.files)
        controller.tabBarItem = UITabBarItem(withIcon: ._429Icon, size: CGSize(width: 22, height: 22),
                                             title: tr(.files))
        navigationController?.pushViewController(controller, animated: false)
    }
}

extension FilesCoordinator: FilesViewControllerDelegate {
    func selectedFile(_ file: File) {
        let coordinator = FileDetailCoordinator(navigationController: navigationController,
                                                contextManager: contextManager, provider: provider,
                                                fileID: file.name)

        childCoordinators.append(coordinator)

        coordinator.completed = { [weak self] in
            _ = self?.childCoordinators.popLast()
        }

        coordinator.start()
    }
}
