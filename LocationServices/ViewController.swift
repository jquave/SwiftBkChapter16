//
//  ViewController.swift
//  LocationServices
//
//  Created by Jameson Quave on 9/22/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var totalDistanceTraveled = 0.0
    var lastKnownLocation : CLLocation?
    
    let locationManager = CLLocationManager()
    let locationLabel = UILabel(frame: UIScreen.mainScreen().bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = "You can now suspend the app and record distance traveled."
        locationLabel.textAlignment = .Center
        locationLabel.numberOfLines = 3
        self.view.addSubview(locationLabel)
        
        startReportingLocation()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: nil) { (notification) -> Void in
            let distInFt = round(self.totalDistanceTraveled * 3.28084 * 100.0) / 100.0
            self.locationLabel.text = "Distance Traveled\n \(distInFt)ft"
        }
    }
    
    func startReportingLocation() {
        // Set the delegate for the location manager
        locationManager.delegate = self
        
        // Specify we'd like the highest level of accuracy available on this device
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Ask the user for permission to use their location in the background
        locationManager.requestAlwaysAuthorization()
        
        // Start producing updates
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        if let location = locations.first {
            if let lastLocation = lastKnownLocation {
                // Find the distance to the previous location
                let distance = lastLocation.distanceFromLocation(location)
                totalDistanceTraveled += distance
                
                /*
                // Uncomment this for real-time updates (consumes more battery power, but good for testing)
                let distInFt = round(self.totalDistanceTraveled * 3.28084 * 100.0) / 100.0
                self.locationLabel.text = "Distance Traveled\n \(distInFt)ft"
                */
            }
            lastKnownLocation = location
        }
    }

}