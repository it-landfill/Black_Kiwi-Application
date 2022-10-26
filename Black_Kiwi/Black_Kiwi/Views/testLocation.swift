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

func randomPointInDisk(radius: Double) -> (Double, Double) {
    let angle = 2 * Double.pi * Double.random(in: 0...1)
    let r = radius * sqrt(Double.random(in: 0...1))
    return (r * cos(angle), r * sin(angle))
}

func randomLocationInRadius(userLocation: CLLocationCoordinate2D, radius: Double) -> Location {
    let randomPoint = randomPointInDisk(radius: radius)
    let latitude = userLocation.latitude + kilometersToDegreesLatitude(kilometers: randomPoint.0)
    let longitude = userLocation.longitude + kilometersToDegreesLongitude(km: randomPoint.1, latitude: latitude)
    return Location(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
}

func kilometersToDegreesLatitude(kilometers: Double) -> Double {
    return kilometers / 111.111
}

func kilometersToDegreesLongitude(km: Double, latitude: Double) -> Double {
    return km / (111.111 * cos(latitude * Double.pi / 180))
}

func generateFakeLocations(_ location: CLLocationCoordinate2D) -> [Location] {
    // Number of dummies.
    let count = 10
    // List of random locations.
    var locations: [Location] = []
    
    for _ in 0..<count {
        locations.append(randomLocationInRadius(userLocation: location, radius: 0.5))
    }
    
    for location in locations{
        print(location)
    }
    
    return locations
}

struct testAPI_Previews: PreviewProvider {
    static var previews: some View {
        testLocation()
            .previewDevice("iPhone 13")
        
    }
}
