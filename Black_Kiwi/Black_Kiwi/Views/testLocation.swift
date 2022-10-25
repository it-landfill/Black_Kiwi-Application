//
//  testAPI.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/10/22.
//

import SwiftUI
import CoreLocation
import MapKit
import Drawer
import PermissionsSwiftUILocation

struct testLocation: View {
    
    @State private var mapRegion = MapSettings.defaultMapRegion
    @State private var annotations: [Location] = []
    @State private var showPermissionPopup = false;
    @State private var restHeights:[CGFloat] = [130,300,600];
    @State private var locationManager: LocationManager = LocationManager()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .edgesIgnoringSafeArea(.vertical)
            HStack {
                Drawer {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .shadow(radius: 100)
                        
                        VStack {
                            Button(action: {
                                // Richiamo la funzione di elaborazione location e salvo i risultati in annotations
                                print("Generating fake location")
                                if let location = locationManager.getCoordinates() {
                                    annotations = generateFakeLocations(location)
                                }
                                
                            }, label: {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.gray)
                                    Text("Generate fake location")
                                        .foregroundColor(.black)
                                }
                                .frame(height: 50)
                                .padding([.top, .horizontal], 20)
                            })
                            Button(action: {
                                print("Clearing fake locations")
                                annotations = []
                                
                            }, label: {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.gray)
                                    Text("Clear fake locations")
                                        .foregroundColor(.black)
                                }
                                .frame(height: 50)
                                .padding([.horizontal],20)
                            })
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .center) {
                            Spacer().frame(height: 4.0)
                            RoundedRectangle(cornerRadius: 3.0)
                                .foregroundColor(.gray)
                                .frame(width: 30.0, height: 6.0)
                            Spacer()
                        }
                    }
                }
                .rest(at: $restHeights)
                .frame(maxWidth: 400)
                Spacer()
            }
            .padding(.leading, 20)
        }
        .onAppear(perform: {
            showPermissionPopup = true;
        })
        .JMAlert(showModal: $showPermissionPopup, for: [.location], autoDismiss: true)
        .setPermissionComponent(for: .location, description: "Allow access to user location while using the app.")
    }
    
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

func generateFakeLocations(_ location: CLLocationCoordinate2D) -> [Location] {
    return [
        Location(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)),
        Location(coordinate: CLLocationCoordinate2D(latitude: 44.48836217722139, longitude: 11.329221725463867)),
        Location(coordinate: CLLocationCoordinate2D(latitude: 44.49433189374523, longitude: 11.343083381652832))
    ]
}

struct testAPI_Previews: PreviewProvider {
    static var previews: some View {
        testLocation()
            .previewDevice("iPhone 13")
        
    }
}
