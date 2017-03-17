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

    func setupWireMock() {
        let parameters = [
                "request": [
                        "method": "POST",
                        "url": "/locations"
                ],
                "response": [
                        "status": 200,
                        "body": ""
                ]
        ]

        let _ = Alamofire.request(
                "http://localhost:9999/__admin/mappings/new",
                method: .post, parameters: parameters, encoding: JSONEncoding.default
        )
    }

    func testMainView() {
        expect(self.app.navigationBars.staticTexts["Your Current Location"].exists).to(beTrue())
        sleep(10)

        expect(self.app.staticTexts["Latitude: 37.785834° N"].exists).to(beTrue())
        expect(self.app.staticTexts["Longitude: 122.406417° W"].exists).to(beTrue())

        let femaleSwitch = self.app.switches["FemaleSwitch"]
        expect(femaleSwitch.exists).to(beTrue())
        femaleSwitch.tap()

        let parameters = [
            "method": "POST",
            "url": "/locations"
        ]

        Alamofire.request("http://localhost:9999/__admin/requests/count",
                          method: .post, parameters: parameters, encoding: JSONEncoding.default
        ).responseJSON { response in
            if let result = response.result.value {

            }
        }

        // let requests = JSON.parse(http.get("localhost:9999/some/route/we/made/requests"))
        // expect(requests.count).to(equal(0))

        let updateButton = self.app.buttons["UPDATE"]
        expect(updateButton.exists).to(beTrue())
        updateButton.tap()

        expect(self.app.alerts["Success"].staticTexts["SENT: Not Female (37.785834, -122.406417)"].exists).to(beTrue())
        // let requests = JSON.parse(http.get("localhost:9999/some/route/we/made/requests"))
        // expect(requests.count).to(equal(1))
    }
}
