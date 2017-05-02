//
//  JobPreviewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell with job preview image and file name text
class JobPreviewCell: UICollectionViewCell, TypedCell {

    /// Reuse identifier of cell
    static let identifier = "JobPreviewCell"

    // MARK: Public API

    /// Image with current job preview
    let jobPreviewImage: UIImageView = {
        let view = UIImageView()

        view.contentMode = .center

        return view
    }()

    /// Title of current print job
    let jobTitleLable: UILabel = {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: .subheadline)

        return label
    }()

    // MARK: Private properties

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(jobPreviewImage)
        contentView.addSubview(jobTitleLable)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        jobPreviewImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        jobTitleLable.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
    }

    // MARK: Internal logic
}
