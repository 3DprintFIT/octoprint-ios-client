//
//  UIViewController+ErrorPresentable.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 08/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

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
