//
//  DetailCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Printer detail flow controller
final class DetailCoordinator: TabCoordinator {
    override func start() {
        let controller = DetailViewController()

        controller.title = tr(.printerDetail)
        addTab(controller: controller)
    }
}