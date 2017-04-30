//
//  DetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 30/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift
import Result

// MARK: - Inputs

/// Printer detail logic inputs
protocol DetailViewModelInputs {
    /// Call when user tap on controls button
    func controlsButtonTapped()
}

// MARK: - Outputs

/// Printer detail logic outputs
protocol DetailViewModelOutputs {

}

// MARK: - Common public interface

/// Common interface for detail View Models
protocol DetailViewModelType {
    /// Available inputs
    var inputs: DetailViewModelInputs { get }

    /// Available outputs
    var outputs: DetailViewModelOutputs { get }
}

// MARK: - View Model implementation

/// Printer detail logic
final class DetailViewModel: DetailViewModelType, DetailViewModelInputs, DetailViewModelOutputs {
    var inputs: DetailViewModelInputs { return self }

    var outputs: DetailViewModelOutputs { return self }

    // MARK: Inputs

    // MARK: Outputs

    // MARK: Private properties

    /// Printer requests provider
    private let provider: OctoPrintProvider

    /// Detail flow delegate
    private weak var delegate: DetailViewControllerDelegate?

    // MARK: Initializers

    init(delegate: DetailViewControllerDelegate, provider: OctoPrintProvider) {
        self.delegate = delegate
        self.provider = provider
    }

    // MARK: Input methods

    // MARK: Output methods

    func controlsButtonTapped() {
        delegate?.controlsButtonTapped()
    }

    // MARK: Internal logic
}
