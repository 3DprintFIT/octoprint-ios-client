//
//  PrinterListCellViewModel.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 27/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import ReactiveSwift
import Icons
import class UIKit.UIImage

/// Cell inputs
protocol PrinterListCellViewModelInputs {

}

/// Cell logic outputs
protocol PrinterListCellViewModelOutputs {
    /// Name of stored printer
    var printerName: Property<String> { get }

    /// URL of printer
    var printerURL: Property<String> { get }

    /// Image of printer stream
    var printerStream: Property<UIImage?> { get }
}

/// View model for printer list cell
protocol PrinterListCellViewModelType {
    /// Available inputs
    var inputs: PrinterListCellViewModelInputs { get }

    /// Available outputs
    var outputs: PrinterListCellViewModelOutputs { get }
}

/// View model for printer list cell
final class PrinterListCellViewModel: PrinterListCellViewModelInputs, PrinterListCellViewModelOutputs,
PrinterListCellViewModelType {

    var inputs: PrinterListCellViewModelInputs { return self }

    var outputs: PrinterListCellViewModelOutputs { return self }

    // MARK: Outputs

    let printerName: Property<String>

    let printerURL: Property<String>

    let printerStream: Property<UIImage?>

    // MARK: Private properties

    /// Octoprint requests provider
    private let provider = StaticContentProvider()

    /// Holds current value of stream illustration
    private let streamProperty = MutableProperty<UIImage?>(PrinterListCellViewModel.imageForIcon(.questionIcon))

    init(printer: Printer) {
        self.printerName = Property(value: printer.name)
        self.printerURL = Property(value: printer.url.absoluteString)
        self.printerStream = Property(capturing: streamProperty)

        if let url = printer.streamUrl {
            requestStreamImage(url: url)
        }
    }

    /// Requests stream photo from given URL
    ///
    /// - Parameter url: URL of streamg
    private func requestStreamImage(url: URL) {
        provider.request(.get(url))
            .filterSuccessfulStatusCodes()
            .startWithResult { [weak self] result in
                switch result {
                case let .success(response): self?.streamProperty.value = UIImage(data: response.data)
                case .failure: self?.streamProperty.value = PrinterListCellViewModel.imageForIcon(.minusSignIcon)
                }
            }
    }

    /// Creates preconfigured image from given icon
    ///
    /// - Parameter icon: Icon to be converted to image
    /// - Returns: New image generated from icon
    private static func imageForIcon(_ icon: FontAwesomeIcon) -> UIImage {
        return icon.image(ofSize: CGSize(width: 100, height: 100), color: Colors.Pallete.greyHue3)
    }
}
