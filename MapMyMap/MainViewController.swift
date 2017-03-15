//
//  MainViewController.swift
//  MapMyMap
//
//  Created by pivotal on 3/14/17.
//  Copyright (c) 2017 Pivotal. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var femaleSwitch: UISwitch!

    var locationManager = CLLocationManager()

    var latitude = 0.0
    var longitude = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Your Current Location"

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: UIControlEvents.touchUpInside)
    }

    func updateButtonTapped() {
        let alertViewController = UIAlertController(
                title: "Success",
                message: "SENT: \(femaleSwitch.isOn ? "" : "Not ")Female (\(latitude), \(longitude))",
                preferredStyle: UIAlertControllerStyle.alert
        )
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!

        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude

        latitudeLabel.text = "Latitude: \(abs(latitude))° \(latitude < 0 ? "S" : "N")"
        longitudeLabel.text = "Longitude: \(abs(longitude))° \(longitude < 0 ? "W" : "E")"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
