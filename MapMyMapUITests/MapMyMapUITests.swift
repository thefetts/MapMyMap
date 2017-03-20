//
//  MapMyMapUITests.swift
//  MapMyMapUITests
//
//  Created by pivotal on 3/14/17.
//  Copyright (c) 2017 Pivotal. All rights reserved.
//

import XCTest

import Nimble
import Alamofire

class MapMyMapUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        UITestHelper.resetWireMock()
        setupWireMock()
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

        UITestHelper.expectRequestCount("/locations", count: 0)

        let updateButton = self.app.buttons["UPDATE"]
        expect(updateButton.exists).to(beTrue())
        updateButton.tap()

        expect(self.app.alerts["Success"].staticTexts["SENT: Not Female (37.785834, -122.406417)"].exists).to(beTrue())

        UITestHelper.expectRequestCount("/locations", count: 1)
    }
}

extension MapMyMapUITests {
    func setupWireMock() {
        let body = [
                "request": [
                        "method": "POST",
                        "url": "/locations",
                        "bodyPatterns": [
                                [
                                        "equalToJson": "{\"female\":false,\"lat\":37.785834,\"lng\":-122.406417}"
                                ]
                        ]
                ],
                "response": [
                        "status": 200,
                        "body": ""
                ]
        ]
        UITestHelper.configureWireMock("mappings/new", method: .post, body: body)
    }
}
