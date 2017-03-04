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
        let controller = FilesViewController()

        controller.title = tr(.files)
        addTab(controller: controller)
    }
}
