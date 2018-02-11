//
//  ValidatingTextFieldTests.swift
//  SafeDataEntry_Tests
//
//  Created by Charles Oder on 2/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import SafeDataEntry

class ValidatingTextFieldTests: XCTestCase {
    
    let testDelegate = TestUITextFieldDelegate()
    let testObject = ValidatingTextField()
    
    override func setUp() {
        super.setUp()
        testObject.errorTextColor = .red
        testObject.textColor = .blue
        testObject.becomeFirstResponder()
    }
    
    func testInvalidColorOnKeypadEntry() {
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        XCTAssertTrue(testObject.textField(testObject, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "a"))
        XCTAssertEqual(UIColor.red, testObject.textColor)
        XCTAssertTrue(testObject.textField(testObject, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "b"))
        XCTAssertEqual(UIColor.red, testObject.textColor)
        XCTAssertTrue(testObject.textField(testObject, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "c"))
        XCTAssertEqual(UIColor.red, testObject.textColor)
        XCTAssertTrue(testObject.textField(testObject, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "d"))
        XCTAssertEqual(UIColor.blue, testObject.textColor)
        
        testObject.text = "d"
        XCTAssertEqual(UIColor.blue, testObject.textColor)
        XCTAssertTrue(testObject.textField(testObject, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: ""))
        XCTAssertEqual(UIColor.red, testObject.textColor)
    }
    
    func testInvalidColorOnProgramaticSetting() {
        testObject.validation = { value in
            return value?.contains("d") == true
        }
        testObject.text = "a"
        XCTAssertEqual(UIColor.red, testObject.textColor)
        testObject.text = "b"
        XCTAssertEqual(UIColor.red, testObject.textColor)
        testObject.text = "c"
        XCTAssertEqual(UIColor.red, testObject.textColor)
        testObject.text = "d"
        XCTAssertEqual(UIColor.blue, testObject.textColor)
        testObject.text = "e"
        XCTAssertEqual(UIColor.red, testObject.textColor)
    }
    

}
