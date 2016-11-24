//
//  PrinterLoginViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/11/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit

final class PrinterLoginViewController: UIViewController {

    private let contextManager: ContextManager

    private let networkController: NetworkController

    private let urlField = UITextField(frame: CGRect.zero)

    private let tokenField = UITextField()

    private let loginButton = UIButton()

    struct Sizes {
        static let textFieldWidth: CGFloat = 60
        static let fieldheight: CGFloat = 44
        static let fieldSpacing: CGFloat = 15
    }

    init(contextManager: ContextManager, networkController: NetworkController) {
        self.contextManager = contextManager
        self.networkController = networkController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func login() {

    }

    //MARK - Private functions

    private func setupUI() {
        urlField.translatesAutoresizingMaskIntoConstraints = false
        tokenField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(urlField)
        view.addSubview(tokenField)
        view.addSubview(loginButton)

        urlField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        urlField.widthAnchor.constraint(equalToConstant: Sizes.textFieldWidth).isActive = true
        urlField.heightAnchor.constraint(equalToConstant: Sizes.fieldSpacing).isActive = true
        urlField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        tokenField.topAnchor.constraint(equalTo: urlField.topAnchor, constant: Sizes.fieldSpacing).isActive = true
        tokenField.widthAnchor.constraint(equalTo: urlField.widthAnchor, constant: 10).isActive = true
        tokenField.heightAnchor.constraint(equalTo: urlField.heightAnchor).isActive = true
        tokenField.centerXAnchor.constraint(equalTo: urlField.centerXAnchor).isActive = true

        urlField.placeholder = "Printer URL"
        tokenField.placeholder = "Access token"

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }

}
