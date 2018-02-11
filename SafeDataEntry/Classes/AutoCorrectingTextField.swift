//
//  AutoCorrectingTextField.swift
//  Pods-SafeDataEntry_Example
//
//  Created by Charles Oder on 2/11/18.
//

import UIKit

@IBDesignable
public class AutoCorrectingTextField: ValidatingTextField {
    
    private var lastValidValue: String?
    private var validTextColor: UIColor? = .black
    private var validationTimer: Timer?
    
    @IBInspectable var resetDelay: Double = 1.0
    
    public override var text: String? {
        set {
            super.text = newValue
            if validation?(newValue) != false {
                lastValidValue = newValue
            } else {
                revert(value: lastValidValue, afterDelay: resetDelay)
            }
        }
        get {
            return super.text
        }
    }
    
    override func validateNewText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let superValidation = super.validateNewText(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        guard let value = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return false
        }

        if validation?(value) != false {
            validationTimer?.invalidate()
            lastValidValue = value
        } else {
            revert(value: lastValidValue, afterDelay: resetDelay)
        }

        return superValidation
    }
    
    private func revert(value: String?, afterDelay delay: TimeInterval) {
        validationTimer?.invalidate()
        
        if #available(iOS 10.0, *) {
            validationTimer = Timer.scheduledTimer(withTimeInterval: delay,
                                                   repeats: false,
                                                   block: { [weak self] timer in
                                                    guard timer.isValid else {
                                                        return
                                                    }
                                                    self?.text = value
            })
        } else {
            validationTimer = Timer.scheduledTimer(timeInterval: delay,
                                                   target: self,
                                                   selector: #selector(revertTimerFired(_:)),
                                                   userInfo: value,
                                                   repeats: false)
        }
        
        
    }
    
    
    @objc
    private func revertTimerFired(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        text = timer.userInfo as? String
    }
    

    
}
