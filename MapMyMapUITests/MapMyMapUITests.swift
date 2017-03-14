//
//  MapMyMapUITests.swift
//  MapMyMapUITests
//
//  Created by pivotal on 3/14/17.
//  Copyright (c) 2017 Pivotal. All rights reserved.
//

import XCTest
import Nimble

class MapMyMapUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        addUIInterruptionMonitor(withDescription: "We wanna know where you are!") {
            (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }

        app.launch()
        continueAfterFailure = false

        app.tap()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMainView() {
        expect(self.app.navigationBars.staticTexts["Your Current Location"].exists).to(beTrue())

        expect(self.app.staticTexts["37.785834° N"].exists).to(beTrue())
        expect(self.app.staticTexts["122.406417° W"].exists).to(beTrue())
    }
}
