//
//  ValidatingTextField.swift
//  Pods-SafeDataEntry_Example
//
//  Created by Charles Oder on 2/11/18.
//

import UIKit

@IBDesignable
public class ValidatingTextField: UITextField {
    
    @IBInspectable public var errorTextColor: UIColor = .red
    
    public var validation: ((String?) -> Bool)?
    
    private var validTextColor: UIColor? = .black
    private weak var injectedDelegate: UITextFieldDelegate?
    
    public override var delegate: UITextFieldDelegate? {
        get {
            return injectedDelegate
        }
        set {
            injectedDelegate = newValue
        }
    }
    
    public override var textColor: UIColor? {
        set {
            validTextColor = newValue
            super.textColor = newValue
        }
        get {
            return super.textColor
        }
    }
    
    public override var text: String? {
        set {
            super.text = newValue
            if validation?(newValue) != false {
                super.textColor = validTextColor
            } else {
                super.textColor = errorTextColor
            }
        }
        get {
            return super.text
        }
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
        super.delegate = self
    }
    
    func validateNewText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 1 {
            print("")
        }
        guard let value = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }
        
        if validation?(value) != false {
            super.textColor = validTextColor
        } else {
            super.textColor = errorTextColor
        }
        
        return true
    }
    
    

}

extension ValidatingTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let overriddenValidation = injectedDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) {
            return overriddenValidation
        }

        return validateNewText(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return injectedDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        injectedDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return injectedDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        injectedDelegate?.textFieldDidEndEditing?(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        injectedDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return injectedDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return injectedDelegate?.textFieldShouldReturn?(textField) ?? true
    }

}
