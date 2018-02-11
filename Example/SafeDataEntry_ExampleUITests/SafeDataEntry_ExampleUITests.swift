//
//  SafeDataEntry_ExampleUITests.swift
//  SafeDataEntry_ExampleUITests
//
//  Created by Charles Oder on 2/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import SafeDataEntry
import XCTest

class SafeDataEntry_ExampleUITests: XCTestCase {
        
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

        app = XCUIApplication()
        
    }
    
    func goToNumericKeypadTests() {
        app/*@START_MENU_TOKEN@*/.buttons["numericEntryKeypad"]/*[[".buttons[\"Numeric Entry Keypad\"]",".buttons[\"numericEntryKeypad\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testTyping() {
        
        goToNumericKeypadTests()
        
        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        app.buttons["1"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1")
        app.buttons["2"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "12")
        app.buttons["3"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "123")
        app.buttons["4"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234")
        app.buttons["."].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.")
        app.buttons["5"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.5")
        app.buttons["6"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.56")
        app.buttons["7"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.567")
        app.buttons["8"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.5678")
        app.buttons["9"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.56789")
        app.buttons["0"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.567890")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.56789")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.5678")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.567")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.56")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.5")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234.")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1234")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "123")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "12")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "")
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "")

    }
    
    func testNegativeNumbers() {
        // ±
        goToNumericKeypadTests()
        
        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        app.buttons["±"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "-")
        app.buttons["±"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "")
        app.buttons["1"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1")
        app.buttons["±"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "-1")
        app.buttons["2"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "-12")
        app.buttons["±"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "12")

    }

    func testChangeDeleteTitle() {

        goToNumericKeypadTests()
        
        app.textFields["deleteTitleField"].tap()
        app.textFields["deleteTitleField"].typeText("X")
        app/*@START_MENU_TOKEN@*/.buttons["save"]/*[[".buttons[\"Save\"]",".buttons[\"save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        
        XCTAssertEqual(dataEntryField.value as? String, "12")
        
        app.buttons["X"].tap()
        app.buttons["X"].tap()

        XCTAssertEqual(dataEntryField.value as? String, "")
        
    }

    func testInsertBlockedByDelegate() {
        goToNumericKeypadTests()
        
        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        app.buttons["1"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "1")
        app.buttons["2"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "12")
        
        app.switches["allowEditingSwitch"].tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["0"].tap()
        app.buttons["±"].tap()
        app.buttons["DEL"].tap()
        XCTAssertEqual(dataEntryField.value as? String, "12")

        app.switches["allowEnterKeySwitch"].tap()
        
    }
    
    func testReturn() {
        goToNumericKeypadTests()
        
        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        
        app.switches["allowEnterKeySwitch"].tap()
        
        app.buttons["DONE"].tap()
        
        XCTAssertTrue(app.buttons["1"].exists)
        
        app.switches["allowEnterKeySwitch"].tap()
        
        app.buttons["DONE"].tap()
        
        XCTAssertFalse(app.buttons["1"].exists)
        
    }
    
    func testReturnTitleChanged() {
        goToNumericKeypadTests()
        
        app.textFields["doneTitleField"].tap()
        app.textFields["doneTitleField"].typeText("SAVE")
        app/*@START_MENU_TOKEN@*/.buttons["save"]/*[[".buttons[\"Save\"]",".buttons[\"save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let dataEntryField = app.textFields["dataEntryField"]
        dataEntryField.tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        
        XCTAssertEqual(dataEntryField.value as? String, "12")
        
        app.buttons["SAVE"].tap()
        XCTAssertFalse(app.buttons["2"].exists)

    }
    
}
