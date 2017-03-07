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
    /// Call when view will appear
    func viewWilAppear()
}

/// Outputs for files view controller
protocol FilesViewModelOutputs {
    /// Emits values when files list was changed
    var filesListChanged: SignalProducer<(), NoError> { get }

    /// Total count of files
    var filesCount: Int { get }

    /// Emits error which should be displayed
    var displayError: Signal<(title: String, message: String), NoError> { get }

    /// View model for collection view cell
    ///
    /// - Parameter index: Index of cell in table
    /// - Returns: View model for given index
    func fileCellViewModel(for index: Int) -> FileCellViewModelType
}

/// Common interface for files view models
protocol FilesViewModelType {
    /// Available inputs
    var inputs: FilesViewModelInputs { get }

    /// Available outputs
    var outputs: FilesViewModelOutputs { get }
}

final class FilesViewModel: FilesViewModelType, FilesViewModelInputs, FilesViewModelOutputs {
    var inputs: FilesViewModelInputs { return self }

    var outputs: FilesViewModelOutputs { return self }

    // MARK: Outputs

    let filesListChanged: SignalProducer<(), NoError>

    let displayError: Signal<(title: String, message: String), NoError>

    var filesCount: Int { return files?.count ?? 0 }

    // MARK: Properties

    /// Property for view will appear input
    private let viewWilAppearProperty = MutableProperty(())

    /// Property for displayimg errors
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

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
        self.displayError = displayErrorProperty.signal.skipNil()

        // Only call download request once, even when
        // the view is loaded more times
        viewWilAppearProperty.producer
            .skip(first: 1)
            .flatMap(.latest) { _ in
                return provider.request(.files)
                    .filterSuccessfulStatusCodes()
                    .mapJSON()
                    .mapTo(collectionOf: File.self, forKeyPath: "files")
            }
            .startWithResult { result in
                switch result {
                case let .success(files):
                    do {
                        let realm = try contextManager.createContext()

                        try realm.write {
                            realm.add(files, update: true)
                        }
                    } catch { }
                case let .failure(error):
                    if case let .underlying(under) = error {
                        if case let JSONAbleError.errorMappingJSONToObject(json) = under {
                            print(json)
                        }
                    }
                    self.displayErrorProperty.value = (tr(.connectionError),
                                                       tr(.filesListCouldNotBeLoaded))
                }
        }
    }

    // MARK: Inputs
    func viewWilAppear() {
        viewWilAppearProperty.value = ()
    }

    // MARK: Output functions 
    func fileCellViewModel(for index: Int) -> FileCellViewModelType {
        assert(files != nil, "Files must not be empty while creating view model")

        return FileCellViewModel(file: files![index])
    }
}
