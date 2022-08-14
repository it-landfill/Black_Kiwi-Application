//
//  MapComponentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        
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
        
    }
    
    
}

struct UIMapView_Previews: PreviewProvider {
    static var previews: some View {
        UIMapView()
            .previewDevice("iPhone 13")
    }
}
