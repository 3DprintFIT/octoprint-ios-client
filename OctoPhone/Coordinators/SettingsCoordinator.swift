//
//  SettingsCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Printer settings flow controller
final class SettingsCoordinator: TabCoordinator {
    override func start() {
        let controller = SettingsViewController()

        controller.title = tr(.settings)
        addTab(controller: controller)
    }
}
