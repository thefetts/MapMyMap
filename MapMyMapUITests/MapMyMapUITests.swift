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

    func testMainView() {
        expect(self.app.navigationBars.staticTexts["Your Current Location"].exists).to(beTrue())

        expect(self.app.staticTexts["Latitude: 37.785834° N"].exists).to(beTrue())
        expect(self.app.staticTexts["Longitude: 122.406417° W"].exists).to(beTrue())

        let femaleSwitch = self.app.switches["FemaleSwitch"]
        expect(femaleSwitch.exists).to(beTrue())
        femaleSwitch.tap()

        let updateButton = self.app.buttons["UPDATE"]
        expect(updateButton.exists).to(beTrue())
        updateButton.tap()

        expect(self.app.alerts["Success"].staticTexts["SENT: Not Female (37.785834, -122.406417)"].exists).to(beTrue())
    }
}
