//
//  FilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift
import Result

/// Inputs from files view controller
protocol FilesViewModelInputs {
    /// Call when view will appear
    func viewWilAppear()

    /// Call when user selected file at specific index
    func selectedFile(at index: Int)
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

/// Files list controller logic
final class FilesViewModel: FilesViewModelType, FilesViewModelInputs, FilesViewModelOutputs {
    var inputs: FilesViewModelInputs { return self }

    var outputs: FilesViewModelOutputs { return self }

    // MARK: Outputs

    let filesListChanged: SignalProducer<(), NoError>

    var filesCount: Int { return filesProperty.value?.count ?? 0 }

    let displayError: Signal<(title: String, message: String), NoError>

    // MARK: Properties

    /// Property for view will appear input
    private let viewWilAppearProperty = MutableProperty(())

    /// Property for displayimg errors
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    /// Holds collection of files
    private let filesProperty = MutableProperty<Results<File>?>(nil)

    /// File list flow delegate
    private weak var delegate: FilesViewControllerDelegate?

    /// Printer connection provider
    private let provider: OctoPrintProvider

    /// Database connections manager
    private let contextManager: ContextManagerType

    init(delegate: FilesViewControllerDelegate, provider: OctoPrintProvider,
         contextManager: ContextManagerType) {

        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.signal.skipNil()
        self.filesListChanged = filesProperty.producer.skipNil().ignoreValues()

        contextManager.createObservableContext().fetch(collectionOf: File.self).startWithResult { [weak self] files in
            switch files {
            case let .success(files): self?.filesProperty.value = files
            case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                               tr(.filesListCouldNotBeLoaded))
            }
        }

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
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(files):
                    do {
                        let realm = try contextManager.createContext()

                        try realm.write {
                            realm.add(files, update: true)
                        }
                    } catch {

                    }
                case let .failure(error):
                    if case let .underlying(under) = error {
                        if case let JSONAbleError.errorMappingJSONToObject(json) = under {
                            print(json)
                        }
                    }
                    weakSelf.displayErrorProperty.value = (tr(.connectionError),
                                                       tr(.filesListCouldNotBeLoaded))
                }
        }
    }

    // MARK: Inputs

    func viewWilAppear() {
        viewWilAppearProperty.value = ()
    }

    func selectedFile(at index: Int) {
        assert(filesProperty.value != nil,
               "Files must not be nil when user selected file at specific index.")

        let file = filesProperty.value![index]

        delegate?.selectedFile(file)
    }

    // MARK: Output functions

    func fileCellViewModel(for index: Int) -> FileCellViewModelType {
        assert(filesProperty.value != nil, "Files must not be empty while creating view model.")

        return FileCellViewModel(file: filesProperty.value![index])
    }
}
