//
//  SDCardManagementViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Controller for SD card management
class SDCardManagementViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: SDCardManagementViewModelType!

    /// View for SD card info
    private let cardView = SDCardView()

    // MARK: - Initializers

    convenience init(viewModel: SDCardManagementViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        view.addSubview(cardView)

        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        let view = cardView
        let outputs = viewModel.outputs

        view.initButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.initButtonTapped()
        }

        view.refreshButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.refreshButtonTapped()
        }

        view.releaseButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.viewModel.inputs.releaseButtonTapped()
        }

        view.stateLabel.reactive.text <~ outputs.state
        view.refreshButton.reactive.title <~ outputs.refreshButtonText
        view.initButton.reactive.title <~ outputs.initButtonText
        view.releaseButton.reactive.title <~ outputs.releaseButtonText

        view.initButton.reactive.isEnabled <~ outputs.initButtonIsEnabled
        view.refreshButton.reactive.isEnabled <~ outputs.refreshButtonIsEnabled
        view.releaseButton.reactive.isEnabled <~ outputs.releaseButtonIsEnabled

        // As refresh and release buttons are exclusive, the bindings must be switched
        view.refreshButton.reactive.isHidden <~ outputs.releaseButtonIsEnabled
        view.releaseButton.reactive.isHidden <~ outputs.refreshButtonIsEnabled
    }
}
