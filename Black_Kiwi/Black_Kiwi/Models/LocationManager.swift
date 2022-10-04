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
    
    private var locationManager: CLLocationManager?
    
    var showDeniedAccessAlert : Binding<Bool> = .constant(false)
    var showRestrictedAccessAlert : Binding<Bool> = .constant(false)
    var locationStatus : Binding<Bool> = .constant(false)
    
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled(){
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager!.desiredAccuracy = kCLLocationAccuracyReduced
            }
            if (locationManager?.authorizationStatus == .denied) {
                locationStatus.wrappedValue = false
                showDeniedAccessAlert.wrappedValue = true
            }
            
            if (locationManager?.authorizationStatus == .restricted) {
                showRestrictedAccessAlert.wrappedValue = true
            }
        } else {
            print("You have to enable location!!")
            locationStatus.wrappedValue = false
        }
        locationStatus.wrappedValue = true
    }
    
    func setAccuracy(accuracy: CLLocationAccuracy){
        locationManager?.desiredAccuracy = accuracy
    }
    
    func getCoordinates() -> CLLocationCoordinate2D?{
        return locationManager?.location?.coordinate ?? nil
    }
    
    func getLocation() -> CLLocation?{
        return locationManager?.location ?? nil
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
