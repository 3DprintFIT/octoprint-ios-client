//
//  SlicingProfileViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import ReactiveSwift

/// Slicing profile detail flow delegate
protocol SlicingProfileViewControllerDelegate: class {
    /// Called when slicing profile was successfully deleted
    func deletedSlicingProfile()
}

/// Slicing profile detail controller
class SlicingProfileViewController: BaseViewController {
    // MARK: - Properties

    /// Profile deletion button
    lazy var deleteButton: UIBarButtonItem = {
        // Fixes weird behavior with not calling target action on `self`
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash,
                               target: self,
                               action: #selector(deleteProfileButtonTapped))
    }()

    /// Profile detail items view
    private let profileView = SlicingProfileView()

    /// Controller logic
    fileprivate var viewModel: SlicingProfileViewModelType!

    // MARK: - Initializers

    convenience init(viewModel: SlicingProfileViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        view.addSubview(profileView)
        edgesForExtendedLayout = []

        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = deleteButton
    }

    // MARK: - Internal logic

    /// Open decision dialog when user tapped delete button
    func deleteProfileButtonTapped() {
        let controller = UIAlertController(title: nil, message: tr(.doYouReallyWantToDeleteSlicingProfile),
                                           preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: tr(.cancel), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: tr(.delete), style: .destructive) { [weak self] _ in
            self?.viewModel.inputs.deleteProfile()
        }

        controller.addAction(cancelAction)
        controller.addAction(deleteAction)

        present(controller, animated: true, completion: nil)
    }

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        let outputs = viewModel.outputs

        viewModel.outputs.title.producer.startWithValues { [weak self] title in self?.title = title }

        profileView.nameLabel.reactive.text <~ outputs.nameText
        profileView.descriptionLabel.reactive.text <~ outputs.descriptionText

        profileView.nameTextLabel.reactive.text <~ outputs.profileName
        profileView.descriptionTextLabel.reactive.text <~ outputs.descriptionText
    }
}
