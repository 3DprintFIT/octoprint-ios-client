//
//  FilesViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import RealmSwift
import Result

/// Inputs from files view controller
protocol FilesViewModelInputs {
    /// Call when view will appear
    func viewWilAppear()

    /// Call when user selected file at specific index
    func selectedFile(at index: Int)

    /// Call when user selected file to upload to printer
    ///
    /// - Parameter url: URL of file located at phone which will be uploaded to printer
    func uploadFile(from url: URL)
}

/// Outputs for files view controller
protocol FilesViewModelOutputs {
    /// Emits values when files list was changed
    var filesListChanged: SignalProducer<(), NoError> { get }

    /// Total count of files
    var filesCount: Int { get }

    /// Emits error which should be displayed
    var displayError: Signal<(title: String, message: String), NoError> { get }

    /// Actual progress of file uploading, while the file is uploaded,
    /// 0 is send to reset value
    var uploadProgress: SignalProducer<Float, NoError> { get }

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

    let uploadProgress: SignalProducer<Float, NoError>

    let displayError: Signal<(title: String, message: String), NoError>

    // MARK: Properties

    /// Property for view will appear input
    private let viewWilAppearProperty = MutableProperty(())

    /// Property for displayimg errors
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    /// Holds collection of files
    private let filesProperty = MutableProperty<Results<File>?>(nil)

    /// Holds the value of current progress of upload task
    private let uploadProgressProperty = MutableProperty<Float>(0)

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
        self.uploadProgress = uploadProgressProperty.producer

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
            .debounce(2, on: QueueScheduler.main)
            .startWithValues { [weak self] in
                self?.downloadFileList()
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

    func uploadFile(from url: URL) {
        let fileName = url.lastPathComponent

        provider.requestWithProgress(.uploadFile(.local, fileName, url))
            // Update progress value on every emitted producer value,
            // reset profress on completed
            // and display error id upload requested failed
            .on(value: { [weak self] progress in
                self?.uploadProgressProperty.value = Float(progress.progress)
            })
            .on(completed: { [weak self] in
                self?.uploadProgressProperty.value = 0
                self?.downloadFileList()
            })
            .startWithFailed({ [weak self] _ in
                self?.displayErrorProperty.value =
                    (tr(.anErrorOccured), tr(.selectedFileCouldNotBeUploaded))
            })
    }

    // Private logic

    private func downloadFileList() {
        provider.request(.files)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapTo(collectionOf: File.self, forKeyPath: "files")
            .startWithResult { [weak self] result in
                guard let weakSelf = self else { return }

                switch result {
                case let .success(files):
                    do {
                        let realm = try weakSelf.contextManager.createContext()

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
}
