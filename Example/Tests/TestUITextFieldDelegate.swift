//
//  TestUITextFieldDelegate.swift
//  SafeDataEntry_Example
//
//  Created by Charles Oder on 2/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

public class TestUITextFieldDelegate: NSObject, UITextFieldDelegate {
    
    public private(set) var textFieldshouldChangeCharactersInRangeArgs: [(UITextField, NSRange, String)] = []
    public var textFieldshouldChangeCharactersInRangeReturnValue = true
    
    public private(set) var textFieldShouldBeginEditingArgs: [UITextField] = []
    public var textFieldShouldBeginEditingReturnValue = true
    
    public private(set) var textFieldDidBeginEditingArgs: [UITextField] = []
    
    public private(set) var textFieldShouldEndEditingArgs: [UITextField] = []
    public var textFieldShouldEndEditingReturnValue = true
    
    public private(set) var textFieldDidEndEditingArgs: [UITextField] = []
    
    public private(set) var textFieldDidEndEditingWithReasonArgs: [(UITextField, Int)] = []
    
    public private(set) var textFieldShouldClearArgs: [UITextField] = []
    public var textFieldShouldClearReturnValue = true
    
    public private(set) var textFieldShouldReturnArgs: [UITextField] = []
    public var textFieldShouldReturnReturnValue = true
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldshouldChangeCharactersInRangeArgs.append((textField, range, string))
        return textFieldshouldChangeCharactersInRangeReturnValue
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldShouldBeginEditingArgs.append(textField)
        return textFieldShouldBeginEditingReturnValue
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldShouldBeginEditingArgs.append(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldShouldEndEditingArgs.append(textField)
        return textFieldShouldEndEditingReturnValue
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidEndEditingArgs.append(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textFieldDidEndEditingWithReasonArgs.append((textField, reason.rawValue))
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textFieldShouldClearArgs.append(textField)
        return textFieldShouldClearReturnValue
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldShouldReturnArgs.append(textField)
        return textFieldShouldReturnReturnValue
    }
}

