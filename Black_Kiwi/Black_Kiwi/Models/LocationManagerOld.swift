//
//  LocationManager.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 31/08/22.
//

import CoreLocation

class LocationManagerOld: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManagerOld()
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        manager.stopUpdatingLocation()
    }
}

extension LocationManagerOld: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("[DEBUG] Not Determined")
        case .restricted:
            print("[DEBUG] Restricted")
        case .denied:
            print("[DEBUG] Denied")
        case .authorizedAlways:
            print("[DEBUG] Always")
        case .authorizedWhenInUse:
            print("[DEBUG] In Use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.userLocation = location
    }
    
    
}
