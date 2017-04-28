//
//  ControlsView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 28/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Printer head controls
class ControlsView: UIView {

    /// Reuse identifier of cell
    static let identifier = "ControlsView"

    // MARK: Public API

    /// Moves head in negative direction on X axis
    let moveLeftButton = ControlsView.moveButton()

    /// Moves head in positive direction on X axis
    let moveRightButton = ControlsView.moveButton()

    /// Moves head in positive direction on Y axis
    let moveForwardButton = ControlsView.moveButton()

    /// Moves head in negative direction on Y axis
    let moveBackButton = ControlsView.moveButton()

    /// Moves head in positive direction on Z axis
    let moveUpButton = ControlsView.moveButton()

    /// Moves head in negative direction on Z axis
    let moveDownButton = ControlsView.moveButton()

    // MARK: Private properties

    /// Holds all views on rounded click wheel
    private let clickWheelView = UIView()

    private let clickStackView: UIStackView

    /// Holds all controls operating on Z axis
    private let roundedControlView: UIStackView

    // MARK: Initializers

    init() {
        self.roundedControlView = UIStackView(arrangedSubviews: [moveUpButton, moveDownButton],
                                              axis: .vertical)
        self.clickStackView = UIStackView(arrangedSubviews: [moveForwardButton, moveBackButton],
                                          axis: .vertical)

        super.init(frame: .zero)

        addSubview(clickWheelView)
        addSubview(roundedControlView)

        clickWheelView.addSubview(clickStackView)
        clickWheelView.addSubview(moveLeftButton)
        clickWheelView.addSubview(moveRightButton)

        roundedControlView.distribution = .equalSpacing
        clickStackView.distribution = .equalSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        clickWheelView.snp.makeConstraints { make in
            make.height.width.equalTo(240)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(50)
        }

        roundedControlView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.height.centerY.equalTo(clickWheelView)
            make.leadingMargin.trailingMargin.equalTo(15)
        }

        clickWheelView.backgroundColor = Colors.Views.defaultControllerBackground
        roundedControlView.backgroundColor = Colors.Views.defaultControllerBackground
        roundedControlView.isLayoutMarginsRelativeArrangement = true
    }

    // MARK: Internal logic

    private static func moveButton() -> UIButton {
        let button = UIButton(type: .custom)

        button.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }

        return button
    }
}
