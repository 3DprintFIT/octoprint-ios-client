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

        view.addSubview(urlField)
        view.addSubview(tokenField)

        urlField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        urlField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        tokenField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tokenField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        tokenField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        urlField.bottomAnchor.constraint(equalTo: tokenField.topAnchor, constant: 10).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
