//
//  FileDetailCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// File detail flow coordinator
class FileDetailCoordinator: ContextCoordinator {
    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Identifier of file to be opened
    private let fileID: String

    /// Creates flow for profile editing o
    ///
    /// - Parameters:
    ///   - navigationController: Controller, where detail will be pushed
    ///   - contextManager: Database connection manager
    ///   - provider: Printer requests provider
    ///   - printProfileID: Edited profile ID, if left out, new profile will be created
    init(navigationController: UINavigationController?, contextManager: ContextManagerType,
         provider: OctoPrintProvider, fileID: String) {

        self.provider = provider
        self.fileID = fileID

        super.init(navigationController: navigationController, contextManager: contextManager)
    }

    override func start() {
        let viewModel = FileDetailViewModel(delegate: self, fileID: fileID, provider: provider,
                                            contextManager: contextManager)
        let controller = FileDetailViewController(viewModel: viewModel)

        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - FileDetailViewControllerDelegate
extension FileDetailCoordinator: FileDetailViewControllerDelegate {
    func deleteFileButtonTapped() {
        navigationController?.popViewController(animated: true)
        completed()
    }
}
