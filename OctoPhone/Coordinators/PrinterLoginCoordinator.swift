//
//  PrinterLoginCoordinator.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

/// Controlls printer login controller flow
final class PrinterLoginCoordinator: ContextCoordinator {

    override func start() {
        let viewModel = PrinterLoginViewModel(delegate: self, contextManager: contextManager)
        let controller = PrinterLoginViewController(viewModel: viewModel)

        navigationController?.present(UINavigationController(rootViewController: controller),
                                      animated: true, completion: nil)
    }
}

/// View controller flow delegate
extension PrinterLoginCoordinator: PrinterLoginViewControllerDelegate {

    func didCancelLogin() {
        finishFlow()
    }

    func successfullyLoggedIn() {
        finishFlow()
    }

    /// Call when screen flow is finished and will be
    private func finishFlow() {
        navigationController?.dismiss(animated: true, completion: nil)
        completed()
    }
}
