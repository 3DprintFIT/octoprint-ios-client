//
//  SlicingProfileView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 22/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// View for slicing profile detail
class SlicingProfileView: UIView {
    // MARK: Public API

    /// Label for profile name text
    let nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .caption1)

        return label
    }()

    /// Actual profile name
    let nameTextField = UITextField()

    /// Label for profile description text
    let descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .caption1)

        return label
    }()

    /// Actual description text
    let descriptionTextField = UITextField()

    /// Label for reference text
    let referenceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .caption1)

        return label
    }()

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private properties

    // MARK: Initializers

    override func layoutSubviews() {
        super.layoutSubviews()

        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, descriptionLabel,
                                                       descriptionTextField, referenceLabel],
                                    axis: .vertical)

        addSubview(stackView)
        stackView.spacing = 10

        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    // MARK: Internal logic
}
