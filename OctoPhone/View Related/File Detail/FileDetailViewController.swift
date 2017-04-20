//
//  FileDetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// File detail flow controller
protocol FileDetailViewControllerDelegate: class {
    /// Called when user tapped on delete button and is decided to delete the file
    func deleteFileButtonTapped()
}

/// File detail controller, allows to manipulate with one specific file.
///
/// File may be selected for print or deleted from printer.
class FileDetailViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: FileDetailViewModelType!

    /// Preconfigured file detail view
    private weak var fileDetailView: FileDetailView!

    /// Button to mark file for print
    private lazy var printButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                     action: #selector(printButtonTapped))

        return button
    }()

    /// Delete file button
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                     action: #selector(deleteButtonTapped))

        return button
    }()

    // MARK: - Initializers

    convenience init(viewModel: FileDetailViewModelType) {
        self.init()

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItems = [deleteButton, printButton]

        let scrollView = UIScrollView()
        let fileDetailView = FileDetailView(
            analysisEnabled: viewModel.outputs.analysisSectionIsEnabled.value,
            statsEnabled: viewModel.outputs.statsSectionIsEnabled.value)

        view.addSubview(scrollView)
        scrollView.addSubview(fileDetailView)
        scrollView.alwaysBounceVertical = true

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        fileDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.fileDetailView = fileDetailView

        bindViewModel()
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        viewModel.outputs.displayError.startWithValues { [weak self] error in
            self?.presentError(title: error.title, message: error.message)
        }

        navigationItem.title = viewModel.outputs.screenTitle.value

        printButton.reactive.isEnabled <~ viewModel.outputs.printIsEnabled

        fileDetailView.attributesHeading.headingLabel.reactive.text <~ viewModel.outputs.attributesHeading
        fileDetailView.fileNameItem.descriptionLabel.reactive.text <~ viewModel.outputs.fileNameLabel
        fileDetailView.fileNameItem.detailLabel.reactive.text <~ viewModel.outputs.fileName

        fileDetailView.sizeItem.descriptionLabel.reactive.text <~ viewModel.outputs.sizeLabel
        fileDetailView.sizeItem.detailLabel.reactive.text <~ viewModel.outputs.size

        fileDetailView.typeItem.descriptionLabel.reactive.text <~ viewModel.outputs.typeLabel
        fileDetailView.typeItem.detailLabel.reactive.text <~ viewModel.outputs.type

        fileDetailView.lastModificationItem.descriptionLabel.reactive.text <~ viewModel.outputs.lastModificationLabel
        fileDetailView.lastModificationItem.detailLabel.reactive.text <~ viewModel.outputs.lastModification

        fileDetailView.analysisHeading.headingLabel.reactive.text <~ viewModel.outputs.analysisHeading

        fileDetailView.filamentLengthItem.descriptionLabel.reactive.text <~ viewModel.outputs.filamentLengthLabel
        fileDetailView.filamentLengthItem.detailLabel.reactive.text <~ viewModel.outputs.filamentLength

        fileDetailView.filamentVolumeItem.descriptionLabel.reactive.text <~ viewModel.outputs.filamentVolumeLabel
        fileDetailView.filamentVolumeItem.detailLabel.reactive.text <~ viewModel.outputs.filamentVolume

        fileDetailView.statsHeading.headingLabel.reactive.text <~ viewModel.outputs.statsHeading
        fileDetailView.successesItem.descriptionLabel.reactive.text <~ viewModel.outputs.printSuccessesLabel
        fileDetailView.successesItem.detailLabel.reactive.text <~ viewModel.outputs.printSuccesses

        fileDetailView.failuresItem.descriptionLabel.reactive.text <~ viewModel.outputs.printFailuresLabel
        fileDetailView.failuresItem.detailLabel.reactive.text <~ viewModel.outputs.printFailures
    }

    /// UI callback for delete button tap event
    func deleteButtonTapped() {
        let controller = DeletionDialogFactory.createDialog(
            title: nil, message: tr(.doYouReallyWantToDeleteFileFromPrinter)) { [weak self] in
                self?.viewModel.inputs.deleteButtonTapped()
            }

        present(controller, animated: true, completion: nil)
    }

    /// UI callback for print button tap event
    func printButtonTapped() {
        viewModel.inputs.printButtonTapped()
    }
}
