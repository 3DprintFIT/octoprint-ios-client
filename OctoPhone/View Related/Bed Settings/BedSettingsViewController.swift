//
//  BedSettingsViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 07/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// Bed settings flow delegate
protocol BedSettingsViewControllerDelegate: class {
    /// Called when user wants to leave screem
    func doneButtonTapped()
}

/// Controller for printer bed temperatures settings
class BedSettingsViewController: BaseViewController {
    // MARK: - Properties

    /// Screen closing buttons
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                     action: #selector(doneButtonTapped))

        return button
    }()

    /// Label for target temperature
    private let targetTempLabel = BedSettingsViewController.inputLabel(text: tr(.targetTemperature))

    /// Label for offset temperature
    private let offsetTempLabel = BedSettingsViewController.inputLabel(text: tr(.offsetTemperature))

    /// Input for bed target temperature
    private let tagetTempField = BedSettingsViewController.inputField(placeholder: tr(.targetTemperature))

    /// Input for bed offset temperature
    private let offsetTempField = BedSettingsViewController.inputField(placeholder: tr(.offsetTemperature))

    /// Controller logic
    fileprivate var viewModel: BedSettingsViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: BedSettingsViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        let stackView = UIStackView(arrangedSubviews: [targetTempLabel, tagetTempField,
                                                       offsetTempLabel, offsetTempField],
                                    axis: .vertical)

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
            make.width.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = doneButton
        edgesForExtendedLayout = []
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        title = viewModel.outputs.title.value
    }

    /// UI Callback for done button tap
    func doneButtonTapped() {
        viewModel.inputs.doneButtonTapped()
    }

    /// Preconfigured label for text input
    ///
    /// - Parameter text: Text of label
    /// - Returns: New prconfigure instance of label
    private static func inputLabel(text: String) -> UILabel {
        let label = UILabel()

        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = text

        return label
    }

    /// Preconfigured text input
    ///
    /// - Parameter placeholder: Placeholder text for input
    /// - Returns: New preconfigured instance of text input
    private static func inputField(placeholder: String) -> UITextField {
        let input = UITextField()

        input.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        input.placeholder = placeholder

        return input
    }
}
