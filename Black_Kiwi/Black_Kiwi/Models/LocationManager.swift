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
    
    static var showDeniedAccessAlert : Binding<Bool> = .constant(false)
    static var showRestrictedAccessAlert : Binding<Bool> = .constant(false)
    static var locationStatus : Binding<Bool> = .constant(false)
    
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled(){
            if LocationManager.locationManager == nil {
                LocationManager.locationManager = CLLocationManager()
                LocationManager.locationManager!.delegate = self
                LocationManager.locationManager!.desiredAccuracy = kCLLocationAccuracyReduced
            }
            if (LocationManager.locationManager?.authorizationStatus == .denied) {
                LocationManager.locationStatus.wrappedValue = false
                LocationManager.showDeniedAccessAlert.wrappedValue = true
            }
            
            if (LocationManager.locationManager?.authorizationStatus == .restricted) {
                LocationManager.showRestrictedAccessAlert.wrappedValue = true
            }
        } else {
            print("You have to enable location!!")
            LocationManager.locationStatus.wrappedValue = false
        }
        LocationManager.locationStatus.wrappedValue = true
    }
    
    static func setAccuracy(accuracy: CLLocationAccuracy){
        LocationManager.locationManager?.desiredAccuracy = accuracy
    }
    
    static func startUpdatingLocation() {
        print("Starting location track")
        LocationManager.locationManager?.startUpdatingLocation()
    }
    
    static func stopUpdatingLocation(){
        print("Stopping location track")
        LocationManager.locationManager?.stopUpdatingLocation()
    }
    
    static func getLocation() -> CLLocation?{
        return LocationManager.locationManager?.location ?? nil
    }
    
    static func getCoordinates() -> CLLocationCoordinate2D?{
        return LocationManager.getLocation()?.coordinate ?? nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("[DEBUG] Not Determined")
        case .restricted:
            print("[DEBUG] Restricted")
            // TODO: Alert popup
            LocationManager.showRestrictedAccessAlert.wrappedValue = true
        case .denied:
            print("[DEBUG] Denied")
            // TODO: Error popup
            LocationManager.showDeniedAccessAlert.wrappedValue = true
            LocationManager.locationStatus.wrappedValue = false
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

extension LocationManager {
    enum PrivacyModels: String, CaseIterable {
        case none = "None"
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
    }
    
    struct PrivacyModel {
        let model: PrivacyModels
        let description: String
    }
    
    static func getPrivacyModelInfo(_ model: PrivacyModels) -> PrivacyModel {
        switch model {
        case .none:
            return PrivacyModel(model: PrivacyModels.none, description: "No privacy")
        case .A:
            return PrivacyModel(model: PrivacyModels.A, description: "Privacy A")
        case .B:
            return PrivacyModel(model: PrivacyModels.B, description: "Privacy B")
        case .C:
            return PrivacyModel(model: PrivacyModels.C, description: "Privacy C")
        case .D:
            return PrivacyModel(model: PrivacyModels.D, description: "Privacy D")
        }
    }
}
