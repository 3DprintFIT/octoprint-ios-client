//
//  FileDetailView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 09/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// View for file detail
class FileDetailView: UIView {

    // MARK: Public API

    /// Heading for attributes section
    let attributesHeading = ListHeadingView()

    /// The file name item
    let fileNameItem = ListItemView()

    /// The file size item
    let sizeItem = ListItemView()

    /// The file type item
    let typeItem = ListItemView()

    /// Last file modification time
    let lastModificationItem = ListItemView()

    /// Heading for analysis section
    let analysisHeading = ListHeadingView()

    /// Filament length item
    let filamentLengthItem = ListItemView()

    /// Filament volume item
    let filamentVolumeItem = ListItemView()

    /// Print stats heading
    let statsHeading = ListHeadingView()

    /// Count of successfull prints
    let successesItem = ListItemView()

    /// Count of failed prints
    let failuresItem = ListItemView()

    // MARK: Private properties

    /// Stack view for list
    private let stackView = UIStackView()

    // MARK: Initializers

    /// Creates new view for file detail
    ///
    /// - Parameters:
    ///   - analysisEnabled: Whether the GCode analysis items are enabled
    ///   - statsEnabled: Whether the print stats items are enabled
    convenience init(analysisEnabled: Bool, statsEnabled: Bool) {
        self.init(frame: .zero)

        stackView.axis = .vertical

        stackView.addArrangedSubview(attributesHeading)
        stackView.addArrangedSubview(fileNameItem)
        stackView.addArrangedSubview(sizeItem)
        stackView.addArrangedSubview(typeItem)
        stackView.addArrangedSubview(lastModificationItem)

        if analysisEnabled {
            stackView.addArrangedSubview(analysisHeading)
            stackView.addArrangedSubview(filamentLengthItem)
            stackView.addArrangedSubview(filamentVolumeItem)
        }

        if statsEnabled {
            stackView.addArrangedSubview(statsHeading)
            stackView.addArrangedSubview(successesItem)
            stackView.addArrangedSubview(failuresItem)
        }

        addSubview(stackView)
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}
