//
//  DetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Icons

/// Printer detail flow interface
protocol DetailViewControllerDelegate: class {
    /// Called when usertappd on controls button
    func controlsButtonTapped()
}

/// Shows basic informations about printer
class DetailViewController: BaseCollectionViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: DetailViewModelType!

    /// Navigation button for controls screen flow
    private lazy var controlsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(withIcon: FontAwesomeIcon._449Icon, size: CGSize(width: 24, height: 24),
                                     target: self, action: #selector(controlsButtonTapped))

        return button
    }()

    /// Connect printer button
    private lazy var connectButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(tr(.connectPrinter), for: .normal)

        return button
    }()

    // MARK: - Initializers

    convenience init(viewModel: DetailViewModelType) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())

        self.viewModel = viewModel
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = controlsButton
        collectionView?.registerTypedCell(cellClass: JobStateCell.self)
        collectionView?.registerTypedCell(cellClass: JobPreviewCell.self)
        collectionView?.registerTypedCell(cellClass: JobInfoCell.self)

        emptyView.addSubview(connectButton)
        emptyView.imageView.image = FontAwesomeIcon.exclamationIcon.image(ofSize: CGSize(width: 50, height: 50),
                                                                          color: Colors.Pallete.greyHue3)
        emptyView.textLabel.text = tr(.printerIsCurrentlyNotInOperationalState)

        connectButton.snp.makeConstraints { make in
            make.top.equalTo(emptyView.textLabel.snp.bottom).offset(15)
            make.centerX.equalTo(emptyView.textLabel)
        }

        bindViewModel()
    }

    // MARK: - Internal logic

    /// UI callback for controls button tap
    func controlsButtonTapped() {
        viewModel.inputs.controlsButtonTapped()
    }

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        if let collectionView = collectionView {
            collectionView.reactive.reloadData <~ viewModel.outputs.dataChanged
        }

        emptyView.reactive.isHidden <~ viewModel.outputs.contentIsAvailable
    }

    fileprivate func dequeueInfoCell(for indexPath: IndexPath, collectionView: UICollectionView,
                                     title: String, detail: String) -> JobInfoCell {

        let cell: JobInfoCell = collectionView.dequeueTypedCell(for: indexPath)

        cell.titleLabel.text = title
        cell.detailLabel.text = detail

        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.outputs.contentIsAvailable.value ? 3 : 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return section == 0 ? 2 : 3
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let outputs = viewModel.outputs

        switch (indexPath.section, indexPath.item) {
        // Print connection state label
        case (0, 0):
            let cell: JobStateCell = collectionView.dequeueTypedCell(for: indexPath)

            cell.stateLabel.text = outputs.printerState.value

            return cell
        // Print job title and illustration
        case (0, 1):
            let cell: JobPreviewCell = collectionView.dequeueTypedCell(for: indexPath)

            cell.jobPreviewImage.image = outputs.jobPreview.value
            cell.jobTitleLable.text = outputs.jobTitle.value

            return cell
        // Job filename
        case (1, 0):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.fileName), detail: outputs.fileName.value)
        // Job print time
        case (1, 1):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.jobPrintTime), detail: outputs.printTime.value)
        // Job print time left
        case (1, 2):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.jobPrintTimeLeft), detail: outputs.estimatedPrintTime.value)
        // Actual bed temperature
        case (2, 0):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.bedTemperature), detail: outputs.bedTemperature.value)
        // Target bed temperature
        case (2, 1):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.bedTemperatureTarget), detail: outputs.bedTemperaturTarget.value)
        // Offset bed temperature
        case (2, 2):
            return dequeueInfoCell(for: indexPath, collectionView: collectionView,
                                   title: tr(.bedTemperatureOffset), detail: outputs.bedTemperatureOffset.value)
        default:
            fatalError("Unexpected IndexPath requested.")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        /// Makes higher the preview cell, the rest is the same
        let height: CGFloat = indexPath.section == 0 && indexPath.item == 1 ? 140 : 44

        return CGSize(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 2, left: 0, bottom: 3, right: 0)
    }
}
