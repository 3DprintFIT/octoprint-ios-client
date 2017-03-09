//
//  FileDetailViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Inputs from view controller
protocol FileDetailViewModelInputs {

}

/// Available outputs for view controller
protocol FileDetailViewModelOutputs {

}

/// Interface for file detail controller
protocol FileDetailViewModelType {
    /// Available file detail inputs
    var inputs: FileDetailViewModelInputs { get }

    /// Available file detail outputs
    var outputs: FileDetailViewModelOutputs { get }
}

/// Handles all logic and routing for file detail controller
final class FileDetailViewModel: FileDetailViewModelType, FileDetailViewModelInputs,
FileDetailViewModelOutputs {

    var inputs: FileDetailViewModelInputs { return self }

    var outputs: FileDetailViewModelOutputs { return self }
}
