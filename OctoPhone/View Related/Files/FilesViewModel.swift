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

    /// Call when user selected new files location
    ///
    /// - Parameter index: New index of selected files location
    func selectedFilesLocation(at index: Int)

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

    /// Indicates which files filter is
    var selectedLocationIndex: ReactiveSwift.Property<Int> { get }

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

    /// Namespace for file colection filters,
    /// use Filter typealias for NSPredicate predicates
    struct Filters {
        typealias Filter = NSPredicate
        /// Does not filter out anything from original collection
        static let all: Filter = NSPredicate(value: true)

        /// Filters only those files, which are stored directly on printer
        static let local: Filter = NSPredicate(format: "_origin = %@", FileOrigin.local.rawValue)

        /// Filters only files located at sdcard
        static let sdcard: Filter = NSPredicate(format: "_origin = %@", FileOrigin.sdcard.rawValue)
    }

    // MARK: Outputs

    let filesListChanged: SignalProducer<(), NoError>

    var filesCount: Int { return filteredFilesProperty.value?.count ?? 0 }

    let uploadProgress: SignalProducer<Float, NoError>

    let selectedLocationIndex: ReactiveSwift.Property<Int>

    let displayError: Signal<(title: String, message: String), NoError>

    // MARK: Properties

    /// Property for view will appear input
    private let viewWilAppearProperty = MutableProperty(())

    /// Property for displayimg errors
    private let displayErrorProperty = MutableProperty<(title: String, message: String)?>(nil)

    /// Holds collection of **all** files, for internal use only,
    /// should not be used as output datasource,
    private let filesProperty = MutableProperty<Results<File>?>(nil)

    /// Holds collection of files which are filtered with currently selected filter
    private let filteredFilesProperty = MutableProperty<Results<File>?>(nil)

    /// Holds the value of current progress of upload task
    private let uploadProgressProperty = MutableProperty<Float>(0)

    /// Current value of selected location index
    private let selectedLocationIndexProperty = MutableProperty<Int>(0)

    /// Currently applied filter on files collection
    private let selectedFilterProperty: ReactiveSwift.Property<Filters.Filter>

    /// File list flow delegate
    private weak var delegate: FilesViewControllerDelegate?

    /// Printer connection provider
    private let provider: OctoPrintProvider

    /// Database connections manager
    private let contextManager: ContextManagerType

    init(delegate: FilesViewControllerDelegate, provider: OctoPrintProvider,
         contextManager: ContextManagerType) {

        let filtersProducer = selectedLocationIndexProperty.producer.map({ index -> Filters.Filter in
            switch index {
            case 0: return Filters.all
            case 1: return Filters.local
            case 2: return Filters.sdcard
            default: fatalError("Whoah, filter index '\(index)' is out of bounds.")
            }
        })

        self.delegate = delegate
        self.provider = provider
        self.contextManager = contextManager
        self.displayError = displayErrorProperty.signal.skipNil()
        self.filesListChanged = filteredFilesProperty.producer.ignoreValues()
        self.uploadProgress = uploadProgressProperty.producer
        self.selectedLocationIndex = Property(capturing: selectedLocationIndexProperty)
        self.selectedFilterProperty = Property(initial: Filters.all, then: filtersProducer)

        // Fetch the realm collection of stored files
        contextManager.createObservableContext().fetch(collectionOf: File.self)
            .startWithResult { [weak self] files in
                switch files {
                case let .success(files): self?.filesProperty.value = files
                case .failure: self?.displayErrorProperty.value = (tr(.anErrorOccured),
                                                                   tr(.filesListCouldNotBeLoaded))
                }
            }

        SignalProducer.combineLatest(
            filesProperty.producer,
            selectedFilterProperty.producer
        )
        .startWithValues { [weak self] files, filter in
            self?.filteredFilesProperty.value = files?.filter(filter)
        }

        // Only call download request once, even when
        // the view is loaded more times
        viewWilAppearProperty.producer
            .skip(first: 1)
            .debounce(2, on: QueueScheduler.main)
            .startWithValues { [weak self] in
                self?.downloadFileList()
            }

        // Just for thesis purpose, downloads files from selected location
        selectedLocationIndexProperty.producer.startWithValues { [weak self] index in
            let location = self?.locationFromIndex(index)
            self?.downloadFileList(location: location)
        }
    }

    // MARK: Inputs

    func viewWilAppear() {
        viewWilAppearProperty.value = ()
    }

    func selectedFile(at index: Int) {
        assert(filteredFilesProperty.value != nil,
               "Files must not be nil when user selected file at specific index.")

        let file = filteredFilesProperty.value![index]

        delegate?.selectedFile(file)
    }

    func selectedFilesLocation(at index: Int) {
        selectedLocationIndexProperty.value = index
    }

    // MARK: Output functions

    func fileCellViewModel(for index: Int) -> FileCellViewModelType {
        assert(filteredFilesProperty.value != nil, "Files must not be empty while creating view model.")

        return FileCellViewModel(file: filteredFilesProperty.value![index])
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

    // MARK: Private logic

    /// Downloads list of files from specific location. If no location is provided
    /// files from all locations are downloaded
    ///
    /// - Parameter location: Remote location of files, nil for all locations combine
    private func downloadFileList(location: FileOrigin? = nil) {
        let request: OctoPrintAPI = location == nil ? .files : .filesAtLocation(location!)

        provider.request(request)
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

    private func locationFromIndex(_ index: Int) -> FileOrigin? {
        switch index {
        case 0: return nil
        case 1: return .local
        case 2: return .sdcard
        default: fatalError("Location index '\(index)' is out of locations bounds.")
        }
    }
}
