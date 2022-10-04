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
    
    private var locationManager: CLLocationManager
    
    var showDeniedAccessAlert : Binding<Bool> = .constant(false)
    var showRestrictedAccessAlert : Binding<Bool> = .constant(false)
    var locationStatus : Binding<Bool> = .constant(false)
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        print("Init LM")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        if let location = locationManager.location {
            UIMapView.centerOnPoint(point: location.coordinate)
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled(){
            if (locationManager.authorizationStatus == .denied) {
                locationStatus.wrappedValue = false
                showDeniedAccessAlert.wrappedValue = true
            }
            
            if (locationManager.authorizationStatus == .restricted) {
                showRestrictedAccessAlert.wrappedValue = true
            }
        } else {
            print("You have to enable location!!")
            locationStatus.wrappedValue = false
        }
        locationStatus.wrappedValue = true
    }
    
    func setAccuracy(accuracy: CLLocationAccuracy){
        locationManager.desiredAccuracy = accuracy
    }
    
    func getCoordinates() -> CLLocationCoordinate2D?{
        return getLocation()?.coordinate ?? nil
    }
    
    func getLocation() -> CLLocation?{
        return locationManager.location ?? nil
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
            showRestrictedAccessAlert.wrappedValue = true
        case .denied:
            print("[DEBUG] Denied")
            // TODO: Error popup
            showDeniedAccessAlert.wrappedValue = true
            locationStatus.wrappedValue = false
        case .authorizedAlways:
            print("[DEBUG] Always")
        case .authorizedWhenInUse:
            print("[DEBUG] In Use")
        @unknown default:
            break
        }
    }
}

extension LocationManager {
    enum PrivacyModels: String, Codable, CaseIterable {
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
