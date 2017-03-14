//
//  TerminalViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

/// CLI terminal controller
class TerminalViewController: BaseCollectionViewController {

    /// Terminal logic
    private var viewModel: TerminalViewModelType!

    /// Terminal input view
    private let terminalInputView = TerminalInputView()

    /// Bottom constraint for keyboard appearence animations
    private var terminalViewBottomConstraint: Constraint?

    override func loadView() {
        super.loadView()

        view.addSubview(terminalInputView)

        terminalInputView.snp.makeConstraints { [weak self] make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
            self?.terminalViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }

    convenience init(viewModel: TerminalViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel

        terminalInputView.sendButton.reactive.isEnabled <~ viewModel.outputs.isCommandValid
        terminalInputView.commandField.reactive.continuousTextValues.observeValues { [weak self] value in
            self?.viewModel.inputs.commandChanged(value)
        }
        terminalInputView.sendButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self]_ in
            self?.viewModel.inputs.sendButtonPressed()
        }

        // Change input position based on keyboard frame
        NotificationCenter.default.reactive.keyboardChange.signal
            .observe(on: UIScheduler())
            .filter({ $0.isLocal })
            .observeValues { [weak self] context in
                self?.terminalViewBottomConstraint?.update(offset: -1 * context.endFrame.height)

                UIView.animate(withDuration: context.animationDuration, animations: {
                    self?.view.layoutIfNeeded()
                })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
