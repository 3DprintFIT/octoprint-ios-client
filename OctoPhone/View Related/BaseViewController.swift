//
//  BaseViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Preconfigure controller with common logic and settings
class BaseViewController: UIViewController, ErrorPresentable {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.Views.defaultControllerBackground
    }
}
