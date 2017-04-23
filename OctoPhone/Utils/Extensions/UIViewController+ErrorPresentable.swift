//
//  UIViewController+ErrorPresentable.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 08/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Represents error, which can be presented to user with alert
typealias DisplayableError = (title: String?, message: String?)

protocol ErrorPresentable {
    /// Presents error with given title and message,
    /// allow user to only dismiss the error.
    ///
    /// - Parameters:
    ///   - title: Title of error message
    ///   - message: Actual content of error message
    func presentError(title: String?, message: String?)
}

extension ErrorPresentable where Self: UIViewController {
    func presentError(title: String?, message: String?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: tr(.ok), style: .default, handler: nil)

        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
    }
}

extension Reactive where Base: ErrorPresentable, Base: UIViewController {
    /// Creates new binding target for controllers which are able to display error,
    /// error is presented on main thread and target uses lifetime of its base.
    var displayableError: BindingTarget<DisplayableError> {
        let lifetime = base.reactive.lifetime

        return BindingTarget(on: UIScheduler(), lifetime: lifetime) { [weak base = self.base] error in
            if let base = base {
                base.presentError(title: error.title, message: error.message)
            }
        }
    }
}
