//
//  TestPrivacyLocation.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 30/11/22.
//

import SwiftUI
import CoreLocation
import MapKit

struct TestPrivacyLocation: View {
    
    @State private var mapRegion = MapSettings.defaultMapRegion
    @State private var annotations: [Location] = []
    @State private var locationManager: LocationManager = LocationManager()
    
    @Binding var selectedPrivacyModel: Int
    @Binding var numberOfDummies: Float
    @Binding var perturbation: DummyUpdateModel.NoiseDistribution
    @Binding var radius: Double
    
    // Poisson perturbation
    @Binding var lambda: Double
    
    // Gaussian perturbation
    @Binding var mean: Double
    @Binding var standardDeviation: Double
    
    // Triangular perturbation
    @Binding var min: Double
    @Binding var max: Double
    @Binding var mode: Double
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { location in
            MapMarker(coordinate: location.coordinate)
        }
        .onAppear(perform: {
            if selectedPrivacyModel == 1 {
                numberOfDummies = 1
            }
            
            let dummyUpdateModel = DummyUpdateModel(radius: radius, numberOfDummies: Int(numberOfDummies), noiseDistribution: perturbation, lambda: lambda, min: min, max: max, mode: mode, mean: mean, standard_deviation: standardDeviation)
            if let curLocs = locationManager.getCoordinatesWithNoise(dummyUpdateModel: dummyUpdateModel) {
                curLocs.forEach { loc in
                    annotations.append(Location(coordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)))
                }
            } else {
                print("Unable to get current location for search")
            }
        })
    }
}

struct TestPrivacyLocation_Previews: PreviewProvider {
    static var previews: some View {
        TestPrivacyLocation(selectedPrivacyModel: .constant(1), numberOfDummies: .constant(5), perturbation: .constant(.uniform), radius: .constant(3), lambda: .constant(0), mean: .constant(0), standardDeviation: .constant(0), min: .constant(0), max: .constant(0), mode: .constant(0))
    }
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
