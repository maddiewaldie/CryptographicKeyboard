//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Maddie on 6/4/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    var nextKeyboardButton: UIButton!
    var encryptionMode: String = "Plain Text"
    var keysSetUp: Bool = false
    var shift: Bool = false
    var selectedEncryptionButton: UIButton?
    var keyLabel: UIButton?
    var keyButtons: [UIButton?] = []
    var keys = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
        ["Space"]
    ]
    var keyboardHeight: CGFloat = 0.0
    var keyboardWidth: CGFloat = 0.0
    var caesarCipherKey: Int = 3

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNextKeyboardButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !keysSetUp {
            keyboardHeight = self.view.frame.height
            keyboardWidth = self.view.frame.width
            setupKeys()
            keysSetUp = true
        }
    }

    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }

    func computeCaesarCipherKey() {
        caesarCipherKey = Int.random(in: 1..<26)
    }

    func setupNextKeyboardButton() {
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    func widthForLabel(text: String, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width + 20
    }

    func clearKeys() {
        for key in keyButtons {
            key?.removeFromSuperview()
        }
    }

    func setupKeys() {
        let encryptionOptions = ["Plain Text", "Caesar Cipher", "ROT13"]
        if shift {
            keys = [
                ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
                ["Space"]
            ]
        }
        else {
            keys = [
                ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                ["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
                ["Space"]
            ]
        }

        let spacing: CGFloat = 5
        let buttonHeight: CGFloat = keyboardHeight/5 - 4*spacing
        let buttonWidth: CGFloat = 30
        var yPos: CGFloat = 5
        var totalOptionWidth: CGFloat = 0
        var optionWidths: [CGFloat] = []

        for option in encryptionOptions {
            let optionWidth = widthForLabel(text: option, font: UIFont.systemFont(ofSize: 15))
            optionWidths.append(optionWidth)
            totalOptionWidth += optionWidth
        }
        totalOptionWidth += CGFloat(encryptionOptions.count - 1) * spacing

        let xPosStartOptions = (keyboardWidth - totalOptionWidth) / 2
        var xPosOptions = xPosStartOptions

        for (index, option) in encryptionOptions.enumerated() {
            let optionButton = UIButton(type: .system)
            optionButton.setTitle(option, for: .normal)
            optionButton.tintColor = .black
            optionButton.backgroundColor = .secondarySystemBackground
            optionButton.layer.cornerRadius = 5
            optionButton.translatesAutoresizingMaskIntoConstraints = false
            optionButton.addTarget(self, action: #selector(encryptionOptionTapped(_:)), for: .touchUpInside)
            self.view.addSubview(optionButton)
            keyButtons.append(optionButton)

            let optionWidth = optionWidths[index]
            NSLayoutConstraint.activate([
                optionButton.widthAnchor.constraint(equalToConstant: optionWidth),
                optionButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                optionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: xPosOptions),
                optionButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: yPos)
            ])

            if option == encryptionMode {
                optionButton.backgroundColor = .systemBlue
                optionButton.setTitleColor(.white, for: .normal)
                selectedEncryptionButton = optionButton
            }

            xPosOptions += optionWidth + spacing
        }

        yPos += buttonHeight + spacing
        var xPos: CGFloat = 0

        for row in keys {
            let totalWidth = CGFloat(row.count) * buttonWidth + CGFloat(row.count - 1) * spacing
            let xPosStart = (keyboardWidth - totalWidth) / 2
            xPos = xPosStart

            for key in row {
                let keyButton = UIButton(type: .system)
                keyButton.setTitle(key, for: .normal)
                keyButton.tintColor = .black
                keyButton.backgroundColor = .secondarySystemBackground
                keyButton.layer.cornerRadius = 5
                keyButton.translatesAutoresizingMaskIntoConstraints = false
                keyButton.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
                self.view.addSubview(keyButton)
                keyButtons.append(keyButton)

                NSLayoutConstraint.activate([
                    keyButton.widthAnchor.constraint(equalToConstant: key == "Space" ? buttonWidth * 5 : buttonWidth),
                    keyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
                    keyButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: yPos)
                ])

                if key == "Space" {
                    NSLayoutConstraint.activate([
                        keyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        keyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: xPos)
                    ])
                }

                xPos += buttonWidth + spacing
            }
            yPos += buttonHeight + spacing
        }

        keyLabel = UIButton(type: .system)
        keyLabel?.backgroundColor = .secondarySystemBackground
        keyLabel?.tintColor = .black
        keyLabel?.layer.cornerRadius = 5
        keyLabel?.translatesAutoresizingMaskIntoConstraints = false

        if encryptionMode == "Caesar Cipher" {
            keyLabel?.setTitle("Key: \(caesarCipherKey)", for: .normal)
        } else {
            keyLabel?.isHidden = true
        }

        self.view.addSubview(keyLabel!)
        keyButtons.append(keyLabel)

        NSLayoutConstraint.activate([
            keyLabel!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: xPos+2*buttonWidth),
            keyLabel!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: yPos - buttonHeight - spacing),
            keyLabel!.heightAnchor.constraint(equalToConstant: buttonHeight),
            keyLabel!.widthAnchor.constraint(equalToConstant: widthForLabel(text: keyLabel?.titleLabel?.text ?? "", font: UIFont.systemFont(ofSize: 15)))
        ])
    }

    @objc func keyTapped(_ sender: UIButton) {
        guard let keyTitle = sender.title(for: .normal) else { return }
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        if keyTitle == "⇧" {
            shift.toggle()
            clearKeys()
            setupKeys()
            return
        } else if keyTitle == "⌫" {
            proxy.deleteBackward()
            return
        }

        var textToInsert = keyTitle
        switch encryptionMode {
        case "Caesar Cipher":
            textToInsert = encrypt(text: keyTitle, key: caesarCipherKey)
        case "ROT13":
            textToInsert = rot13(text: keyTitle)
        default:
            break
        }

        proxy.insertText(textToInsert)
    }


    @objc func encryptionOptionTapped(_ sender: UIButton) {
        guard let option = sender.title(for: .normal) else { return }
        selectedEncryptionButton?.backgroundColor = .secondarySystemBackground
        selectedEncryptionButton?.setTitleColor(.black, for: .normal)
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        selectedEncryptionButton = sender
        encryptionMode = option
        computeCaesarCipherKey()
        clearKeys()
        setupKeys()
    }

    func encrypt(text: String, key: Int) -> String {
        var letters = Array("abcdefghijklmnopqrstuvwxyz")
        if shift {
            letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
        let encryptedText = text.map { char -> Character in
            if let index = letters.firstIndex(of: char) {
                let newIndex = (index + key) % letters.count
                return letters[newIndex]
            }
            return char
        }
        return String(encryptedText)
    }

    func rot13(text: String) -> String {
        return encrypt(text: text, key: 13)
    }

    override func textWillChange(_ textInput: UITextInput?) {

    }

    override func textDidChange(_ textInput: UITextInput?) {
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
}
