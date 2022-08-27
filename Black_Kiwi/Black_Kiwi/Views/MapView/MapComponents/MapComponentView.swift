//
//  MapComponentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    
    @Binding var POIList: [POIModel.Item]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.pointOfInterestFilter = .excludingAll
        mapView.addAnnotations(POIList)
        
        mapView.region = MapModel.defaultMapRegion
        
        return mapView
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
    
    
    
}

struct UIMapView_Previews: PreviewProvider {
    static var previews: some View {
        UIMapView(POIList: .constant(POIModel.Item.sampleData))
            .previewDevice("iPhone 13")
    }
}
