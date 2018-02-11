//
//  AutoCorrectingTextFieldTests.swift
//  SafeDataEntry_Tests
//
//  Created by Charles Oder on 2/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import SafeDataEntry

class AutoCorrectingTextFieldTests: XCTestCase {
    
    func testInvalidInputRevertsAfterTimeoutOnKeyboardInput() {
        let timeout = 0.5
        let testObject = AutoCorrectingTextField()
        testObject.errorTextColor = .red
        testObject.textColor = .blue
        testObject.resetDelay = timeout
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        testObject.text = "d"
        
        setCharacterAndWait(textField: testObject, range: NSRange(location: 0, length: 1), value: "a", waitDuration: timeout + 0.1)
        
        XCTAssertEqual("d", testObject.text)
        XCTAssertEqual(UIColor.blue, testObject.textColor)
        
    }
    
    func testInvalidInputDoesNotRevertBeforeTimeoutOnKeyboardInput() {
        let timeout = 0.5
        let testObject = AutoCorrectingTextField()
        testObject.errorTextColor = .red
        testObject.textColor = .blue
        testObject.resetDelay = timeout
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        testObject.text = "d"
        
        setCharacterAndWait(textField: testObject, range: NSRange(location: 0, length: 1), value: "a", waitDuration: timeout - 0.1)
        
        XCTAssertEqual(UIColor.red, testObject.textColor)
        XCTAssertEqual("a", testObject.text)
        
    }
    
    func testInvalidInputRevertsAfterTimeoutWhenSetProgramatically() {
        let timeout = 0.5
        let testObject = AutoCorrectingTextField()
        testObject.errorTextColor = .red
        testObject.textColor = .blue
        testObject.resetDelay = timeout
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        testObject.text = "d"

        setTextAndWait(textField: testObject, value: "a", waitDuration: timeout + 0.1)
        
        XCTAssertEqual(UIColor.blue, testObject.textColor)
        XCTAssertEqual("d", testObject.text)
        
    }
    
    func testInvalidInputDoesNotRevertBeforeTimeoutWhenSetProgramatically() {
        let timeout = 0.5
        let testObject = AutoCorrectingTextField()
        testObject.errorTextColor = .red
        testObject.textColor = .blue
        testObject.resetDelay = timeout
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        testObject.text = "d"
        
        setTextAndWait(textField: testObject, value: "a", waitDuration: timeout - 0.1)
        
        XCTAssertEqual(UIColor.red, testObject.textColor)
        XCTAssertEqual("a", testObject.text)
        
    }
    
    func setTextAndWait(textField: UITextField, value: String, waitDuration: TimeInterval) {
        let testExpectation = expectation(description: UUID().uuidString)
        textField.text = value
        DispatchQueue(label: "test").asyncAfter(deadline: .now() + waitDuration) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: waitDuration + 0.5) { error in
            if error != nil {
                XCTFail()
            }
        }
    }
    
    func setCharacterAndWait(textField: AutoCorrectingTextField, range: NSRange, value: String, waitDuration: TimeInterval) {
        let testExpectation = expectation(description: UUID().uuidString)
        XCTAssertTrue(textField.textField(textField, shouldChangeCharactersIn: range, replacementString: "a"))
        let newValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: value)
        textField.setTextWithoutValidation(newValue)
        DispatchQueue(label: "test").asyncAfter(deadline: .now() + waitDuration) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: waitDuration + 0.5) { error in
            if error != nil {
                XCTFail()
            }
        }
    }
    
}
