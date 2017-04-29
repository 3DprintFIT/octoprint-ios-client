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

    /// Move the print head home on X and Y axis
    let moveHomeXYButton = ControlsView.homeButton()

    /// Moves head in positive direction on Z axis
    let moveUpButton = ControlsView.moveButton()

    /// Moves head in negative direction on Z axis
    let moveDownButton = ControlsView.moveButton()

    /// Moves the print head home on Z axis
    let moveHomeZButton = ControlsView.homeButton()

    // MARK: Private properties

    /// Holds all views on rounded click wheel
    private let clickWheelView = UIView()

    /// Stack for vertically alligned click wheel buttons
    private let clickStackView: UIStackView

    /// Holds all controls operating on Z axis
    private let roundedControlView = UIView()

    /// Stack for vertically aligned rounded controls
    private let roundedStackView: UIStackView

    // MARK: Initializers

    init() {
        self.roundedStackView = UIStackView(arrangedSubviews: [moveUpButton, moveHomeZButton, moveDownButton],
                                            axis: .vertical)
        self.clickStackView = UIStackView(arrangedSubviews: [moveForwardButton, moveHomeXYButton, moveBackButton],
                                          axis: .vertical)

        super.init(frame: .zero)

        addSubview(clickWheelView)
        addSubview(roundedControlView)

        clickWheelView.addSubview(clickStackView)
        clickWheelView.addSubview(moveLeftButton)
        clickWheelView.addSubview(moveRightButton)
        roundedControlView.addSubview(roundedStackView)

        roundedStackView.distribution = .equalSpacing
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
            make.width.equalTo(90)
        }

        moveLeftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }

        moveRightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }

        clickStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().inset(15)
        }

        roundedStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }

        roundedStackView.isLayoutMarginsRelativeArrangement = true
        roundedControlView.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        roundedControlView.backgroundColor = Colors.Views.defaultControllerBackground
        roundedControlView.layer.cornerRadius = 15
        roundedControlView.layer.masksToBounds = true

        clickWheelView.layer.cornerRadius = 125
        clickWheelView.layer.masksToBounds = true
        clickWheelView.backgroundColor = Colors.Views.defaultControllerBackground
    }

    // MARK: Internal logic

    private static func moveButton() -> UIButton {
        let button = UIButton(type: .custom)

        button.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }

        return button
    }

    private static func homeButton() -> UIButton {
        let button = moveButton()

        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .white

        return button
    }
}
