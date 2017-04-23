//
//  SDCardView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 23/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// View for sdcard management
class SDCardView: UIView {

    // MARK: Public API

    /// Button for SD card content refresh
    let refreshButton = RoundedButton(borderWidth: 1, borderColor: Colors.Pallete.greyHue3)

    /// Button for SD card initialization
    let initButton = RoundedButton(borderWidth: 1, borderColor: Colors.Pallete.greyHue3)

    /// Button for SD card release action
    let releaseButton = RoundedButton(borderWidth: 1, borderColor: Colors.Pallete.greyHue3)

    /// Label with current state text
    let stateLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)

        return label
    }()

    // MARK: Private properties

    /// View for displaying SD card state
    private let stateView = UIView()

    /// Sepator between state label from control buttons
    private let separatorView = UIView()

    // MARK: Initializers

    init() {
        super.init(frame: .zero)

        addSubview(stateView)
        addSubview(refreshButton)
        addSubview(initButton)
        addSubview(releaseButton)
        stateView.addSubview(stateLabel)
        stateView.addSubview(separatorView)

        stateView.backgroundColor = .white
        separatorView.backgroundColor = Colors.Views.cellSeparator

        refreshButton.setTitleColor(Colors.Pallete.greyHue3, for: .normal)
        initButton.setTitleColor(Colors.Pallete.greyHue3, for: .normal)
        releaseButton.setTitleColor(Colors.Pallete.greyHue3, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        stateView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(250)
        }

        stateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        separatorView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }

        refreshButton.snp.makeConstraints { make in
            make.top.equalTo(stateView.snp.bottom).offset(50)
            make.centerX.equalTo(snp.leading).inset(100)
            make.width.greaterThanOrEqualTo(70)
        }

        initButton.snp.makeConstraints { make in
            make.top.equalTo(stateView.snp.bottom).offset(50)
            make.centerX.equalTo(snp.trailing).inset(100)
            make.width.equalTo(refreshButton)
        }

        releaseButton.snp.makeConstraints { make in
            make.center.equalTo(initButton)
            make.width.equalTo(initButton)
        }
    }
}
