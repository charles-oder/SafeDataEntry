//
//  NumericEntryKeypad.swift
//  SafeDataEntry
//
//  Created by Charles Oder on 2/10/18.
//

import UIKit

@available(iOS 9.0, *)
public class NumericEntryKeypad: UIView {
    
    public var deleteTitle: String = "DEL" {
        didSet {
            deleteButton.setTitle(deleteTitle, for: .normal)
        }
    }
    
    public var doneTitle: String = "DONE" {
        didSet {
            doneButton.setTitle(doneTitle, for: .normal)
        }
    }
    public var allowsDecimals: Bool = true {
        didSet {
            decimalButton?.isUserInteractionEnabled = allowsDecimals
            upButton?.isUserInteractionEnabled = !allowsDecimals
            downButton?.isUserInteractionEnabled = !allowsDecimals
        }
    }
    
    public var allowsNegatives: Bool = true {
        didSet {
            plusMinusButton.isUserInteractionEnabled = allowsNegatives
        }
    }
    
    private var plusMinusTitle: String = "±"
    private var upTitle: String = "˄"
    private var downTitle: String = "˅"

    private var upButton: UIButton!
    private var downButton: UIButton!
    private var decimalButton: UIButton!
    private var plusMinusButton: UIButton!
    private var deleteButton: UIButton!
    private var doneButton: UIButton!
    private var stackView: UIStackView!
    
    private var textField: UITextField?
    
    public convenience init(allowsNegatives: Bool = true, allowsDecimals: Bool = true, doneTitle: String = "DONE", deleteTitle: String = "DEL") {
        self.init(frame: CGRect.zero)
        self.allowsDecimals = allowsDecimals
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        frame = CGRect(x: 0, y: 0, width: 200, height: 260)
        createButtons()
    }
    
    private func createButton(title: String, isActive: Bool = true) -> UIButton {
        let button = NumberpadButton(title: title)
        button.isUserInteractionEnabled = isActive
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createStackView(axis: UILayoutConstraintAxis, items: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }
    
    private func createButtons() {
        doneButton = createButton(title: doneTitle)
        deleteButton = createButton(title: deleteTitle)
        plusMinusButton = createButton(title: plusMinusTitle, isActive: allowsNegatives)
        decimalButton = createButton(title: ".", isActive: allowsDecimals)
        upButton = createButton(title: upTitle, isActive: !allowsDecimals)
        downButton = createButton(title: downTitle, isActive: !allowsDecimals)
        stackView = createStackView(axis: .vertical, items: [
            createStackView(axis: .horizontal, items: [
                createButton(title: "7"), createButton(title: "8"), createButton(title: "9"), deleteButton
                ]),
            createStackView(axis: .horizontal, items: [
                createButton(title: "4"), createButton(title: "5"), createButton(title: "6"), upButton
                ]),
            createStackView(axis: .horizontal, items: [
                createButton(title: "1"), createButton(title: "2"), createButton(title: "3"), downButton
                ]),
            createStackView(axis: .horizontal, items: [
                decimalButton, createButton(title: "0"), plusMinusButton, doneButton
                ])
            ])
        addSubview(stackView)
    }
    
    @objc
    private func buttonTapped(_ button: UIButton) {
        
        textField = UIView.firstResponder as? UITextField
        
        if button.currentTitle == upTitle {
            incrementValue()
        } else if button.currentTitle == downTitle {
            decrementValue()
        } else if button.currentTitle == plusMinusTitle {
            numericKeypadDidFlipSign()
        } else if button.currentTitle == doneTitle {
            numericKeypadDidFinish()
        } else if button.currentTitle == deleteTitle {
            numericKeypadDidBackspace()
        } else if let value = button.currentTitle {
            numericKeypadDidAddValue(value)
        }
        
        updateButtonVisibility(textValue: textField?.text)
    }
    
    private func updateButtonVisibility(textValue: String?) {
        downButton.isUserInteractionEnabled = !allowsDecimals && Int(textValue ?? "0") != 0
    }
    
    private func incrementValue() {
        guard let unwrappedTextField = textField else {
            return
        }
        let oldString: String = unwrappedTextField.text ?? ""
        let range = NSRange(location: 0, length: oldString.count)
        
        let oldInt = Int(oldString) ?? 0
        let newInt = oldInt + 1
        let newString = "\(newInt)"

        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: "-") != false {
            unwrappedTextField.text = newString
        }
    }
    
    private func decrementValue() {
        guard let unwrappedTextField = textField else {
            return
        }
        let oldString: String = unwrappedTextField.text ?? ""
        let range = NSRange(location: 0, length: oldString.count)

        let oldInt = Int(oldString) ?? 0
        let newInt = oldInt - 1
        let newString = "\(newInt)"
        
        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: "-") != false {
            unwrappedTextField.text = newString
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    class NumberpadButton: UIButton {
        
        override var isUserInteractionEnabled: Bool {
            didSet {
                alpha = isUserInteractionEnabled ? 1 : 0
            }
        }
        
        convenience init(title: String) {
            self.init(frame: CGRect.zero)
            setTitle(title, for: .normal)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            setTitleColor(.darkGray, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 30)
            titleLabel?.textAlignment = .center
            layer.cornerRadius = 5
            clipsToBounds = true
        }
        
        override var isHighlighted: Bool {
            didSet {
                backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.1) : .white
            }
        }
    }
    
    private func numericKeypadDidFlipSign() {
        if textField?.text?.hasPrefix("-") == true {
            removeMinusSign()
        } else {
            insertMinusSign()
        }
    }
    
    private func insertMinusSign() {
        guard let unwrappedTextField = textField else {
            return
        }
        var newString: String = unwrappedTextField.text ?? ""
        let range = NSRange(location: 0, length: 0)
        
        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: "-") != false {
            newString.insert(Character("-"), at: String.Index(encodedOffset: range.location))
            unwrappedTextField.text = newString
        }
    }
    
    private func removeMinusSign() {
        guard let unwrappedTextField = textField else {
            return
        }
        var newString: String = unwrappedTextField.text ?? ""
        let range = NSRange(location: 0, length: 1)
        
        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: "") != false {
            newString.remove(at: newString.startIndex)
            unwrappedTextField.text = newString
        }
    }
    
    private func numericKeypadDidAddValue(_ value: String) {
        guard let unwrappedTextField = textField else {
            return
        }
        var newString: String = unwrappedTextField.text ?? ""
        let range = NSRange(location: newString.count, length: 0)
        
        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: value) != false {
            newString.insert(Character(value), at: String.Index(encodedOffset: range.location))
            unwrappedTextField.text = newString
        }
        
    }
    
    private func numericKeypadDidBackspace() {
        guard let unwrappedTextField = textField else {
            return
        }
        guard let value = unwrappedTextField.text else {
            return
        }
        guard value.isEmpty != true else {
            return
        }
        let lastCharacterIndex = value.count - 1
        let range = NSRange(location: lastCharacterIndex, length: 1)
        if unwrappedTextField.delegate?.textField?(unwrappedTextField, shouldChangeCharactersIn: range, replacementString: "") != false {
            unwrappedTextField.text = String(value.prefix(upTo: value.index(value.endIndex, offsetBy: -1)))
        }
    }
    
    private func numericKeypadDidFinish() {
        guard let unwrappedTextField = textField else {
            return
        }
        if unwrappedTextField.delegate?.textFieldShouldReturn?(unwrappedTextField) != false {
            unwrappedTextField.resignFirstResponder()
            unwrappedTextField.delegate?.textFieldDidEndEditing?(unwrappedTextField)
        }
    }
    
}

extension UIViewController {
    
    public class var top: UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        
        return topController
    }
}

extension UIView {
    
    static var firstResponder: UIView? {
        return UIViewController.top?.view.findFirstResponder()
    }
    
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for view in subviews {
            if let responder = view.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
