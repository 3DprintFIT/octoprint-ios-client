//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

class TerminalInputView: UIView {

    weak var commandSignLabel: UILabel!

    weak var commandField: UITextField!

    weak var sendButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        // Layout

        let commandSignLabel = UILabel()
        let commandField = UITextField()
        let sendButton = UIButton(type: .system)
        let horizontalStack = UIStackView(arrangedSubviews: [commandSignLabel, commandField, sendButton])
        let topBorder = UIView()

        commandSignLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 15.0
        horizontalStack.distribution = .fill
        horizontalStack.alignment = .center
        horizontalStack.frame = frame

        self.commandSignLabel = commandSignLabel
        self.commandField = commandField
        self.sendButton = sendButton
        self.addSubview(horizontalStack)

        let verticalStack = UIStackView(arrangedSubviews: [])

        // View

        commandSignLabel.textColor = UIColor(red: 200/255, green: 200/255, blue: 206/255, alpha: 1.0)
        commandField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        commandSignLabel.text = "$"
        commandField.placeholder = "Command"
        commandField.borderStyle = .roundedRect

        sendButton.setTitle("Send", for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

PlaygroundPage.current.liveView = TerminalInputView(frame: CGRect(x: 0, y: 0, width: 324, height: 42))
