//
//  DetailUnavailableView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 02/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit

/// View for empty detail data set,
/// offers imageview and text label to display informations.
/// Boths views are alway centered to the screen
class DetailUnavailableView: UIView {

    // MARK: Public API

    /// Illustration for empty screen
    let imageView = UIImageView()

    /// Text which shows informations about empty set
    let textLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = Colors.Pallete.greyHue4
        label.numberOfLines = 0

        return label
    }()

    // MARK: Initializers

    /// Contentview which centers both image view and text label 
    /// to the center of screen
    private let contentView = UIView()

    init() {
        super.init(frame: .zero)

        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.bottom.equalTo(textLabel)
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.leading.trailing.equalToSuperview()
        }
    }

    // MARK: Interal logic

}
