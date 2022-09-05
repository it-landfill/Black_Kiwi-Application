//
//  MapComponentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    
    private static let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        
        UIMapView.mapView.delegate = context.coordinator
        UIMapView.mapView.pointOfInterestFilter = .excludingAll
        
        UIMapView.mapView.setRegion(MapModel.defaultMapRegion, animated: false)
        
        return UIMapView.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UIMapView
        
        init(_ parent: UIMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // Apply annotation texture only to POIModel.Item items (does not apply to user location for example)
            // returning nil applies the default texture
            guard let annotation = annotation as? POIModel.Item else {
                return nil
            }
            
            
            let identifier = "POI"
            var view: MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(
                withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                
                view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: 0, y: 20)
                view.glyphImage = UIImage(systemName: annotation.categoryStruct.icon)
                view.markerTintColor = UIColor(annotation.categoryStruct.color)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        
    }
    
    static func updateRegion(region: MKCoordinateRegion) {
        UIMapView.mapView.region = region;
    }
    
    static func updatePOIs(POIList: [POIModel.Item]){
        UIMapView.mapView.addAnnotations(POIList)
    }
    
    static func centerOnPoint(point: CLLocationCoordinate2D){
        print("Centering on lat: \(point.latitude)\tlon: \(point.longitude)")
        UIMapView.mapView.setRegion(MKCoordinateRegion(center: point, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
    }
    
    static func startTrackingUser(){
        UIMapView.mapView.showsUserLocation = true
    }
    
    static func stopTrackingUser(){
        UIMapView.mapView.showsUserLocation = false
    }
    
}

struct UIMapView_Previews: PreviewProvider {
    static var previews: some View {
        UIMapView()
            .previewDevice("iPhone 13")
    }
}
