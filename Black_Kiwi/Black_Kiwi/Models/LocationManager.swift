//
//  LocationManager.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 01/09/22.
//

import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    
    private static var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            if LocationManager.locationManager == nil {
                LocationManager.locationManager = CLLocationManager()
                LocationManager.locationManager!.delegate = self
                LocationManager.locationManager!.desiredAccuracy = kCLLocationAccuracyReduced
            }
        } else {
            print("You have to enable location!!")
        }
    }
    
    static func setAccuracy(accuracy: CLLocationAccuracy){
        LocationManager.locationManager?.desiredAccuracy = accuracy
    }
    
    static func startUpdatingLocation() {
        LocationManager.locationManager?.startUpdatingLocation()
    }
    
    static func stopUpdatingLocation(){
        LocationManager.locationManager?.stopUpdatingLocation()
    }
    
    static func getLocation() -> CLLocationCoordinate2D?{
        return LocationManager.locationManager?.location?.coordinate ?? nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("[DEBUG] Not Determined")
            // TODO: Show auth popup
        case .restricted:
            print("[DEBUG] Restricted")
            // TODO: Alert popup
        case .denied:
            print("[DEBUG] Denied")
            // TODO: Error popup
        case .authorizedAlways:
            print("[DEBUG] Always")
        case .authorizedWhenInUse:
            print("[DEBUG] In Use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Auto centering map on user")
        if let location = locations.last {
            UIMapView.centerOnPoint(point: location.coordinate)
        }
    }
}

