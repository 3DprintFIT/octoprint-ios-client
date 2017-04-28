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
    fileprivate var viewModel: TerminalViewModelType!

    /// Terminal input view
    private let terminalInputView = TerminalInputView()

    /// Bottom constraint for keyboard appearence animations
    private var terminalViewBottomConstraint: Constraint?

    override func loadView() {
        super.loadView()

        view.addSubview(terminalInputView)

        terminalInputView.snp.makeConstraints { [weak self] make in
            guard let weakSelf = self else { return }

            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
            self?.terminalViewBottomConstraint =
                make.bottom.equalTo(weakSelf.bottomLayoutGuide.snp.top).constraint
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

        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.commandsChanged
            collectionView.register(CommandCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CommandCollectionViewCell.identifier)
        }

        // Change input position based on keyboard frame
        NotificationCenter.default.reactive.keyboardChange.signal
            .observe(on: UIScheduler())
            .filter({ $0.isLocal })
            .observeValues { [weak self] context in
                guard let weakSelf = self, let collectionView = self?.collectionView else { return }

                let offset = context.endFrame.height
                var inset = collectionView.contentInset

                weakSelf.terminalViewBottomConstraint?.update(offset: -offset)
                inset.bottom = offset + weakSelf.terminalInputView.frame.height
                collectionView.contentInset = inset

                UIView.animate(withDuration: context.animationDuration, animations: {
                    self?.view.layoutIfNeeded()
                })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionViewDataSource
extension TerminalViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.commandsCount
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommandCollectionViewCell.identifier, for: indexPath
            ) as! CommandCollectionViewCell

        cell.viewModel.value = viewModel.outputs.commandCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TerminalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 42)
    }
}
