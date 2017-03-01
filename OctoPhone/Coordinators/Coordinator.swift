//
//  Coordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Interface for flow controllers
protocol CoordinatorType {
    /// Method which starts flow
    func start()

    var completed: () -> Void { get set }
}

/// Base Coordinator for classes which does not require context manager
class Coordinator: CoordinatorType {
    /// Main app navigation controller
    var navigationController: UINavigationController?

    /// Called when controllers flow is completed, should be implemented by parent coordinator
    var completed: () -> Void = { }

    /// Stack of coordinators created with this coordinator
    var childCoordinators = [CoordinatorType]()

    /// Initializer for flows which does not require context manager
    ///
    /// - Parameter navigationController: Main app navigation controller
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// Starts the coordinator flow
    func start() { }
}

/// Base Coordinator for classes which requires context manager
class ContextCoordinator: CoordinatorType {
    /// Main app navigation controller
    weak var navigationController: UINavigationController?

    /// Called when controllers flow is completed, should be implemented by parent coordinator
    var completed: () -> Void = { }

    /// Database connections manager
    let contextManager: ContextManagerType

    /// Stack of coordinators created with this coordinator
    var childCoordinators = [CoordinatorType]()

    /// Initializer for flows which requires context manager
    ///
    /// - Parameters:
    ///   - navigationController: Main app flow controller
    ///   - contextManager: Database connections manager
    init(navigationController: UINavigationController?, contextManager: ContextManagerType) {
        self.navigationController = navigationController
        self.contextManager = contextManager
    }

    /// Starts the coordinator flow
    func start() { }
}
