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

    var locationManager = CLLocationManager()

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Your Current Location"
        
        locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.first!
        latitude.text = "\(abs(loc.coordinate.latitude))° \(loc.coordinate.latitude < 0 ? "S" : "N")"
        longitude.text = "\(abs(loc.coordinate.longitude))° \(loc.coordinate.longitude < 0 ? "W" : "E")"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
