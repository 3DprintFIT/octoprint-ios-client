//
//  FilesViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 20/12/16.
//  Copyright © 2016 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

/// File list flow delegate
protocol FilesViewControllerDelegate: class {
    /// Called when user selected file to expand detail
    ///
    /// - Parameter file: File to be expanded
    func selectedFile(_ file: File)
}

/// Lists stored files on printer
class FilesViewController: BaseCollectionViewController {

    /// Upload progress indicator view
    fileprivate let progressBar = UIProgressView(progressViewStyle: .bar)

    /// Button to allow user to pick document to upload
    private lazy var pickDocumentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                     action: #selector(showDocumentPicker))

        return button
    }()

    /// Segment control for
    private let locationSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [tr(.allFiles), tr(.filesOnPrinter),
                                                 tr(.filesOnCard)])

        return control
    }()

    /// Controller view model
    fileprivate var viewModel: FilesViewModelType!

    convenience init(viewModel: FilesViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    override func loadView() {
        super.loadView()

        let toolbar = UIToolbar()

        view.addSubview(toolbar)
        view.addSubview(progressBar)
        toolbar.addSubview(locationSegmentControl)

        toolbar.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(toolbar.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        locationSegmentControl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        collectionView?.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = pickDocumentButton
        automaticallyAdjustsScrollViewInsets = false
        collectionView?.contentOffset = CGPoint(x: 0, y: 0)

        bindViewModel()

        collectionView?.register(FileCollectionViewCell.self,
                                 forCellWithReuseIdentifier: FileCollectionViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWilAppear()
    }

    // MARK: Internal logic

    func showDocumentPicker() {
        let controller = UIDocumentMenuViewController(documentTypes: [UTI.gcode, UTI.stl],
                                                      in: UIDocumentPickerMode.import)
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    /// Binds View Model to the UI elements
    private func bindViewModel() {
        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.filesListChanged
        }

        progressBar.reactive.progress <~ viewModel.outputs.uploadProgress
        locationSegmentControl.reactive.selectedSegmentIndex <~ viewModel.outputs.selectedLocationIndex

        viewModel.outputs.displayError
            .observe(on: UIScheduler())
            .observeValues { [weak self] title, message in
                self?.presentError(title: title, message: message)
        }

        locationSegmentControl.reactive.selectedSegmentIndexes
            .skipRepeats()
            .observeValues { [weak self] index in
                self?.viewModel.inputs.selectedFilesLocation(at: index)
            }
    }
}

// MARK: - UICollectionViewDataSource
extension FilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return viewModel.outputs.filesCount
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FileCollectionViewCell.identifier,
            for: indexPath
        ) as! FileCollectionViewCell

        cell.viewModel.value = viewModel.outputs.fileCellViewModel(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 44)
    }
}

// MARK: - UICollectionViewDelegate
extension FilesViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        viewModel.inputs.selectedFile(at: indexPath.row)
    }
}

// MARK: - UIDocumentMenuDelegate
extension FilesViewController: UIDocumentMenuDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController,
                      didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}

// MARK: - UIDocumentPickerDelegate
extension FilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        viewModel.inputs.uploadFile(from: url)
    }
}

extension FilesViewController: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
