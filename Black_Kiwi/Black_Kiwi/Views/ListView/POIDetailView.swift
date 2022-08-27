//
//  POIDetailView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI
import MapKit

struct POIDetailView: View {
    
    @Binding var POI: POIModel.Item
    @State private var region: MKCoordinateRegion = MapModel.defaultMapRegion
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [POI]) { item in
                MapMarker(coordinate: item.coordinate, tint: Color.red)
            }
            .padding(.all)
            .frame(height: 300)
            .onAppear {
                setRegion(POI.coordinate)
            }
            List {
                Section("Info") {
                    HStack{
                        Text("Category")
                        Spacer()
                        Text(POI.categoryStruct.name)
                    }
                    HStack{
                        Text("Distance")
                        Spacer()
                        Text("\(POI.distance, specifier: "%.1f") Km")
                    }
                    HStack{
                        Text("Rank")
                        Spacer()
                        Text("\(POI.rank, specifier: "%.1f")")
                    }
                }
            }
        }
        .navigationTitle(POI.title!)
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MapModel.defaultPOISpan
        )
    }
}

struct POIDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            POIDetailView(POI: .constant(POIModel.Item.sampleData[0]))
            
        }
        .previewDevice("iPhone 13")
    }
}
