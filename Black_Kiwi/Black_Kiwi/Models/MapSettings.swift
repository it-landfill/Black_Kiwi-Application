//
//  MapModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import Foundation
import MapKit

final class MapSettings: ObservableObject {
    @Published var mapType = 0
    @Published var pointOfInterestFilter: MKPointOfInterestFilter = .excludingAll
    @Published var poiList: [POIModel.Item] = POIModel.Item.sampleData
    @Published var showUserLocation: Bool = false
    @Published var mapRegion: MKCoordinateRegion = defaultMapRegion
    
}

extension MapSettings {
    static let defaultMapCoordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 44.4949, longitude: 11.3426)
    static let defaultMapSpan : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    static let defaultPOISpan : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    static let defaultMapRegion : MKCoordinateRegion = MKCoordinateRegion(center: defaultMapCoordinates, span: defaultMapSpan)
}
