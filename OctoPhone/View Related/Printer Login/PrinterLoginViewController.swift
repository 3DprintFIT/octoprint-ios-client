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

    private let urlField = UITextField()

    private let tokenField = UITextField()

    private let loginButton = UIButton(type: .system)

    struct Sizes {
        static let groupTopSpacing: CGFloat = 50
        static let textFieldWidth: CGFloat = 180
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

        configureView()
    }

    func login() {
        validateForm()
    }

    //MARK - Private functions

    private func configureView() {
        let components = [urlField, tokenField, loginButton]

        components.forEach { component in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }

        urlField.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.groupTopSpacing).isActive = true
        urlField.widthAnchor.constraint(equalToConstant: Sizes.textFieldWidth).isActive = true
        urlField.heightAnchor.constraint(equalToConstant: Sizes.fieldSpacing).isActive = true
        urlField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        tokenField.topAnchor.constraint(equalTo: urlField.bottomAnchor, constant: Sizes.fieldSpacing).isActive = true
        tokenField.widthAnchor.constraint(equalTo: urlField.widthAnchor).isActive = true
        tokenField.heightAnchor.constraint(equalTo: urlField.heightAnchor).isActive = true
        tokenField.centerXAnchor.constraint(equalTo: urlField.centerXAnchor).isActive = true

        loginButton.topAnchor.constraint(equalTo: tokenField.bottomAnchor, constant: Sizes.fieldSpacing).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: urlField.centerXAnchor).isActive = true

        urlField.placeholder = NSLocalizedString("PRINTER_URL", comment: "")
        tokenField.placeholder = NSLocalizedString("PRINTER_ACCESS_TOKEN",comment: "")
        loginButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)

        edgesForExtendedLayout = []
    }

    private func validateForm() {
        guard let url = urlField.text, let token = tokenField.text else {
            print("Form fields must be filled in.")
            return
        }

        guard url.characters.count > 5, token.characters.count > 2 else {
            print("Form values are not valid.")
            return
        }
    }

}
