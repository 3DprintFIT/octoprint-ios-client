//
//  JobStateCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell with job state
class JobStateCell: UICollectionViewCell, TypedCell {

    /// Reuse identifier of cell
    static let identifier = "JobStateCell"

    // MARK: Public API

    /// Label for job state
    let stateLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center

        return label
    }()

    // MARK: Private properties

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(stateLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        stateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Internal logic
}
