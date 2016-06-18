//
//  ezlangUITests.swift
//  ezlangUITests
//
//  Created by Andriy Puhach on 11/19/15.
//  Copyright © 2015 5wheels. All rights reserved.
//

import XCTest

class ezlangUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSettingsGridSize() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.buttons["Settings"].tap()
        tablesQuery.buttons["Big"].tap()
        
        
        XCTAssert(tablesQuery.buttons["Big"].selected == true)
        app.buttons["arr24"].tap()
    }
    
    func testSettingsSound() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.buttons["Settings"].tap()
        tablesQuery.buttons["Off"].tap()
        
        
        XCTAssert(tablesQuery.buttons["Off"].selected == true)
        
        app.buttons["arr24"].tap()
    }
    
    func testSettingsTranslationDirection() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.buttons["Settings"].tap()
        tablesQuery.buttons["UKR->ENG"].tap()
        
        XCTAssert(tablesQuery.buttons["UKR->ENG"].selected == true)
        app.buttons["arr24"].tap()

        
    }
    
    
}
