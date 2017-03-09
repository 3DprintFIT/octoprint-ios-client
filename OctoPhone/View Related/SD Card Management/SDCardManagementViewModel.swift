//
//  SDCardManagementViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// SD card management inputs
protocol SDCardManagementViewModelInputs {

}

/// SD card management outputs
protocol SDCardManagementViewModelOutputs {

}

/// Common interface for SD card managing view models
protocol SDCardManagementViewModelType {
    /// Avaialable SD card management inputs
    var inputs: SDCardManagementViewModelInputs { get }

    /// Avaialable SD card management outputs
    var outputs: SDCardManagementViewModelOutputs { get }
}

/// SD Card management logic
final class SDCardManagementViewModel: SDCardManagementViewModelType,
SDCardManagementViewModelInputs, SDCardManagementViewModelOutputs {

    var inputs: SDCardManagementViewModelInputs { return self }

    var outputs: SDCardManagementViewModelOutputs { return self }
}
