//
//  NumericEntryKeypadViewController.swift
//  SafeDataEntry_Example
//
//  Created by Charles Oder on 2/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SafeDataEntry

class NumericEntryKeypadViewController: UIViewController {

    @IBOutlet weak var dataEntryField: UITextField!
    @IBOutlet weak var allowEditingSwitch: UISwitch!
    @IBOutlet weak var allowEnterKeySwitch: UISwitch!
    @IBOutlet weak var deleteTitleField: UITextField!
    @IBOutlet weak var doneTitleField: UITextField!
    
    var keypad = NumericEntryKeypad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataEntryField.inputView = keypad
        dataEntryField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        keypad.deleteTitle = deleteTitleField.text ?? "DEL"
        keypad.doneTitle = doneTitleField.text ?? "DONE"
    }
}

extension NumericEntryKeypadViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return allowEnterKeySwitch.isOn
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return allowEditingSwitch.isOn
    }
}
