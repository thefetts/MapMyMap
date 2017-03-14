//
//  MainViewControllerTest.swift
//  MapMyMapTests
//
//  Created by pivotal on 3/14/17.
//  Copyright (c) 2017 Pivotal. All rights reserved.
//

import Quick
import Nimble
import CoreLocation

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
                        subject.view.layoutSubviews()

                        expect(subject.latitude.text).to(equal("37.4° N"))
                        expect(subject.longitude.text).to(equal("104.7° W"))
                    }

                    it("can do E and S values") {
                        mockManager.nextLongitude = 78.1
                        mockManager.nextLatitude = -42.0

                        subject.view.layoutSubviews()

                        expect(subject.latitude.text).to(equal("42.0° S"))
                        expect(subject.longitude.text).to(equal("78.1° E"))
                    }
                }
            }
        }
    }
}

class MockCLLocationManager: CLLocationManager {
    var nextLongitude: Double = -104.7
    var nextLatitude: Double = 37.4

    override func requestLocation() {
        delegate!.locationManager!(self, didUpdateLocations: [
                CLLocation(
                        latitude: CLLocationDegrees(nextLatitude),
                        longitude: CLLocationDegrees(nextLongitude))
        ])
    }
}