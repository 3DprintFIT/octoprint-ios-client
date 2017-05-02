//
//  JobInfoCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Cell with key-value display
class JobInfoCell: UICollectionViewCell, TypedCell {

    /// Reuse identifier of cell
    static let identifier = "JobInfoCell"

    // MARK: Public API

    /// Title of cell (key)
    let titleLabel = UILabel()

    /// Detail text (value)
    let detailLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .right

        return label
    }()

    // MARK: Private properties

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)

        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(detailLabel.snp.leading)
            make.leading.equalToSuperview().inset(15)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }

        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    }

    // MARK: Internal logic
}
