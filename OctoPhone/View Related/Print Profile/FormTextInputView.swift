//
//  FormTextInputView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 04/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit

class FormTextInputView: UIView {

    weak var descriptionLabel: UILabel!

    weak var textField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        let descriptionLabel = UILabel()
        let textField = UITextField()

        descriptionLabel.text = "Name"
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 15, bottom: 0, right: 15))
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        addSubview(descriptionLabel)
        addSubview(textField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
