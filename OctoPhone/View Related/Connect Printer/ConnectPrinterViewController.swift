//
//  ConnectPrinterViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Icons

/// Connect printer controller flow delegate
protocol ConnectPrinterViewControllerDelegate: class {
    /// Called when user decided to close controller
    func closeButtonTapped()
}

/// Controller which allows to connect octoprint to specific
/// printer interface.
class ConnectPrinterViewController: BaseViewController {
    // MARK: - Properties

    /// Close controller button
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel,
                                     target: self, action: #selector(closeButtonTapped))

        return button
    }()

    /// Button for port connection request
    private lazy var connectButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                     action: #selector(connectButtonTapped))

        return button
    }()

    /// Picker with list of available connections
    private let connectionPicker = UIPickerView()

    /// Controller logic
    fileprivate var viewModel: ConnectPrinterViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: ConnectPrinterViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = connectButton

        connectionPicker.delegate = self
        connectionPicker.dataSource = self
        view.addSubview(connectionPicker)

        connectionPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        title = viewModel.outputs.title.value

        reactive.displayableError <~ viewModel.outputs.displayError
        connectButton.reactive.isEnabled <~ viewModel.outputs.selectionIsEnabled
        connectionPicker.reactive.reloadAllComponents <~ viewModel.outputs.connectionsChanged
        connectionPicker.reactive.isUserInteractionEnabled <~ viewModel.outputs.selectionIsEnabled

        connectionPicker.reactive.selections.observeValues { [weak self] row, _ in
            self?.viewModel.inputs.selectedConnection(at: row)
        }

        // Force picker to select first element when data are changed,
        // this is required because when picker value is selected programatically,
        // the didSelect delegate func is not called
        viewModel.outputs.connectionsChanged.startWithValues { [weak self] in
            if self?.viewModel.outputs.selectionIsEnabled.value == true {
                self?.viewModel.inputs.selectedConnection(at: 0)
            }
        }
    }

    /// UI action close button callback
    func closeButtonTapped() {
        viewModel.inputs.closeButtonTapped()
    }

    /// UI action connect button callback
    func connectButtonTapped() {
        viewModel.inputs.connect()
    }
}

// MARK: - UIPickerViewDataSource
extension ConnectPrinterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.outputs.availableConnectionsCount
    }
}

// MARK: - UIPickerViewDelegate
extension ConnectPrinterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {

        return viewModel.outputs.connectionLabel(at: row)
    }
}
