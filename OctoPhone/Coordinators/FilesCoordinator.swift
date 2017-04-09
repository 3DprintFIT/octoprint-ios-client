//
//  FilesCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Stored files list coordinator
final class FilesCoordinator: TabCoordinator {
    override func start() {
        let viewModel = FilesViewModel(delegate: self, provider: provider, contextManager: contextManager)
        let controller = FilesViewController(viewModel: viewModel)

        controller.title = tr(.files)
        addTab(controller: controller)
    }
}

extension FilesCoordinator: FilesViewControllerDelegate {
    func selectedFile(_ file: File) {
        let coordinator = FileDetailCoordinator(navigationController: navigationController,
                                                contextManager: contextManager, provider: provider,
                                                fileID: file.name)

        childCoordinators.append(coordinator)

        coordinator.start()
    }
}
