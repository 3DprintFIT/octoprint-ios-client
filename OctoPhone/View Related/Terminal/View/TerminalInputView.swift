//
//  TerminalInputView.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 12/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit

/// View for terminal compose
class TerminalInputView: UIView {

    /// Command line indicator label
    weak var commandSignLabel: UILabel!

    /// Input for commands
    weak var commandField: UITextField!

    /// Send button
    weak var sendButton: UIButton!

    init() {
        super.init(frame: CGRect.zero)

        // Layout

        let commandSignLabel = UILabel()
        let commandField = UITextField()
        let sendButton = UIButton(type: .system)
        let topBorder = UIView()
        let views = [commandSignLabel, commandField, sendButton]
        let horizontalStack = UIStackView(arrangedSubviews: views, axis: .horizontal,
                                          spacing: 15, distribution: .fill, alignment: .center)

        commandSignLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        self.commandSignLabel = commandSignLabel
        self.commandField = commandField
        self.sendButton = sendButton

        addSubview(topBorder)
        addSubview(horizontalStack)

        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(topBorder.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }

        // View
        backgroundColor = .white
        commandSignLabel.textColor = UIColor(red: 200/255, green: 200/255, blue: 206/255,
                                             alpha: 1.0)
        commandSignLabel.text = tr(.sendCommandIndicator)
        commandField.placeholder = tr(.command)
        commandField.borderStyle = .roundedRect
        commandField.autocorrectionType = .no
        commandField.autocapitalizationType = .none
        commandField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255,
                                               alpha: 1.0)
        topBorder.backgroundColor = UIColor(red: 230/255, green: 228/255, blue: 228/255, alpha: 1.0)
        sendButton.setTitle(tr(.send), for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
