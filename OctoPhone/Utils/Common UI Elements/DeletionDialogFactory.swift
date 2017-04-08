//
//  DeletionDialogFactory.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 08/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Utility factory for deletion dialog creation
class DeletionDialogFactory {
    /// Creates new deletion decision dialog with delete and cancel action.
    ///
    /// - Parameters:
    ///   - title: Title of deletion dialog
    ///   - message: Message for dialog
    ///   - deleteAction: Action called when user selected delete action
    static func createDialog(title: String?, message: String?,
                             deleteAction: @escaping () -> Void) -> UIAlertController {

        let controller = UIAlertController(title: title, message: message,
                                           preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: tr(.cancel), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: tr(.delete), style: .destructive,
                                         handler: { _ in deleteAction() })

        controller.addAction(cancelAction)
        controller.addAction(deleteAction)

        return controller
    }
}
