//
//  LogDetailViewController.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

/// Log detail screen controller
class LogDetailViewController: BaseViewController {
    // MARK: - Properties

    /// Controller logic
    fileprivate var viewModel: LogDetailViewModelType!

    /// Log content text view
    private let contentTextView: UITextView = {
        let textView = UITextView()

        textView.isEditable = false

        return textView
    }()

    // MARK: - Initializers

    convenience init(viewModel: LogDetailViewModelType) {
        self.init()

        self.viewModel = viewModel
        bindViewModel()
    }

    override func loadView() {
        super.loadView()

        view.addSubview(contentTextView)

        contentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - Internal logic

    /// Binds outputs of View Model to UI and converts
    /// user interaction to View Model inputs
    private func bindViewModel() {
        contentTextView.reactive.text <~ viewModel.outputs.content
    }
}
