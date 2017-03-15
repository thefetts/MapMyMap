//
//  MainViewControllerTest.swift
//  MapMyMapTests
//
//  Created by pivotal on 3/14/17.
//  Copyright (c) 2017 Pivotal. All rights reserved.
//

import CoreLocation

import Quick
import Nimble
import Fleet

@testable import MapMyMap

class MainViewControllerTest: QuickSpec {
    override func spec() {
        describe("MainViewController") {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            var subject: MainViewController!

            let mockManager = MockCLLocationManager()

            beforeEach {
                subject = storyboard.instantiateViewController(
                        withIdentifier: "MainViewController") as! MainViewController
                subject.locationManager = mockManager
            }

            describe("viewDidLoad") {
                context("user location") {
                    it("sets the labels based on the device's location data") {
                        _ = Fleet.setInAppWindowRootNavigation(subject)

                        expect(subject.latitudeLabel.text).to(equal("Latitude: 37.4° N"))
                        expect(subject.longitudeLabel.text).to(equal("Longitude: 104.7° W"))
                    }

                    it("can do E and S values") {
                        mockManager.nextLatitude = -42.0
                        mockManager.nextLongitude = 78.1

                        _ = Fleet.setInAppWindowRootNavigation(subject)

                        expect(subject.latitudeLabel.text).to(equal("Latitude: 42.0° S"))
                        expect(subject.longitudeLabel.text).to(equal("Longitude: 78.1° E"))
                    }
                }

                context("femaleSwitch") {
                    it("defaults on") {
                        _ = Fleet.setInAppWindowRootNavigation(subject)

                        expect(subject.femaleSwitch.isOn).to(beTrue())
                    }
                }
            }

            describe("updateButtonTapped") {
                describe("presented UIAlertController") {
                    it("displays the sent coordinates") {
                        mockManager.nextLatitude = -42.0
                        mockManager.nextLongitude = 78.1
                        _ = Fleet.setInAppWindowRootNavigation(subject)

                        try! subject.updateButton.tap()

                        expect(subject.presentedViewController).to(beAKindOf(UIAlertController.self))
                        let expectedAlertController = subject.presentedViewController as! UIAlertController

                        expect(expectedAlertController.title).to(equal("Success"))
                        expect(expectedAlertController.message).to(contain(["(-42.0, 78.1)"]))
                    }

                    context("when female switch is on") {
                        it("says Female") {
                            _ = Fleet.setInAppWindowRootNavigation(subject)

                            try! subject.updateButton.tap()

                            let expectedAlertController = subject.presentedViewController as! UIAlertController
                            expect(expectedAlertController.message).to(contain(["Female"]))
                            expect(expectedAlertController.message).toNot(contain(["Not"]))
                        }
                    }

                    context("when female switch is off") {
                        it("says Not Female") {

                            _ = Fleet.setInAppWindowRootNavigation(subject)

                            try! subject.femaleSwitch.flip()
                            try! subject.updateButton.tap()

                            let expectedAlertController = subject.presentedViewController as! UIAlertController
                            expect(expectedAlertController.message).to(contain(["Not Female"]))
                        }
                    }
                }
            }
        }
    }
}

class MockCLLocationManager: CLLocationManager {
    var nextLatitude: Double = 37.4
    var nextLongitude: Double = -104.7

    override func requestLocation() {
        delegate!.locationManager!(self, didUpdateLocations: [
                CLLocation(
                        latitude: CLLocationDegrees(nextLatitude),
                        longitude: CLLocationDegrees(nextLongitude))
        ])
    }
}
