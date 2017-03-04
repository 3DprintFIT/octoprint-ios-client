//
//  FilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import Result

/// Inputs from files view controller
protocol FilesViewModelInputs {
    /// Call when view did load
    func viewDidLoad()
}

/// Outputs for files view controller
protocol FilesViewModelOutputs {
    var filesListChanged: SignalProducer<(), NoError> { get }
}

/// Common interface for files view models
protocol FilesViewModelType: FilesViewModelInputs, FilesViewModelOutputs {
    /// Available inputs
    var inputs: FilesViewModelInputs { get }

    /// Available outputs
    var outputs: FilesViewModelOutputs { get }
}

final class FilesViewModel: FilesViewModelType {
    var inputs: FilesViewModelInputs { return self }

    var outputs: FilesViewModelOutputs { return self }

    // MARK: Outputs
    let filesListChanged: SignalProducer<(), NoError>

    // MARK: Properties

    /// Property for view did load input
    private let viewDidLoadProperty = MutableProperty(())

    /// Printer connection provider
    private let provider: OctoPrintProvider

    /// Database connections manager
    private let contextManager: ContextManagerType

    private var files: Results<File>?

    init(provider: OctoPrintProvider, contextManager: ContextManagerType) {
        self.provider = provider
        self.contextManager = contextManager

        do {
            let realm = try contextManager.createContext()

            files = realm.objects(File.self)
        } catch { }

        self.filesListChanged = files?.producer ?? SignalProducer(value: ())

    }

    // MARK: Inputs
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }
}
