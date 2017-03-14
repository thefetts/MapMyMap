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

        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        expect(self.app.navigationBars.staticTexts["Your Current Location"].exists).to(beTrue())
    }

}
