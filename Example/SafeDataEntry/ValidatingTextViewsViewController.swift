//
//  ValidatingTextViewsViewController.swift
//  SafeDataEntry_Example
//
//  Created by Charles Oder on 2/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SafeDataEntry

class ValidatingTextViewsViewController: UIViewController {

    @IBOutlet weak var validationStringField: UITextField!
    @IBOutlet weak var validatingTextField: ValidatingTextField!
    @IBOutlet weak var autoCorrectingTextField: AutoCorrectingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validatingTextField.validation = validation
        autoCorrectingTextField.validation = validation
    }
    
    var validation: (String?) -> Bool {
        return { [weak self] value in
            guard let comparisonString = self?.validationStringField.text else {
                return true
            }
            
            if comparisonString.isEmpty {
                return true
            }
            
            return value?.contains(comparisonString) == true
        }
    }

}
