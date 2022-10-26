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
                                    // TODO: Parametrizzare il numero di dummies richiesti
                                    annotations = generateFakeLocations(location, .poisson, 10)
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

enum NoiseDistribution {
    case uniform
    case gaussian
    case poisson
    case triangular
}

// Funzione che permette di trasformare da kilometri a gradi (da applicare alla latitudine)
func kilometersToDegreesLatitude(kilometers: Double) -> Double {
    return kilometers / 111.111
}

// Funzione che permette di trasformare da kilometri a gradi (da applicare alla longitudine)
func kilometersToDegreesLongitude(km: Double, latitude: Double) -> Double {
    return km / (111.111 * cos(latitude * Double.pi / 180))
}

func poisson_random_generator(_ lambda: Double) -> Double {
    let L = exp(-lambda)
    var p = 1.0
    var k = 0
    repeat {
        k += 1
        p *= Double.random(in: 0...1)
    } while p > L
    return Double(k - 1)
}

// Funzione che calcolato l'angolo e la distanza dal centro, ritorna le due componenti, rispettivamente
// per la latitudine e la longitudine (distribuzione poisson).
func poissonPointInDisk(radius: Double, lam: Double, k: Int) -> (Double, Double) {
    let r = radius * sqrt(poisson_random_generator(lam))
    print("Poisson raggio: ", r)
    let angle = 2 * Double.pi * Double.random(in: 0...1)
    return (r * cos(angle), r * sin(angle))
}

// Funzione che calcolato l'angolo e la distanza dal centro, ritorna le due componenti, rispettivamente
// per la latitudine e la longitudine (distribuzione uniforme).
func uniformPointInDisk(radius: Double) -> (Double, Double) {
    let r = radius * sqrt(Double.random(in: 0...1))
    let angle = 2 * Double.pi * Double.random(in: 0...1)
    return (r * cos(angle), r * sin(angle))
}

// Funzione che ritorna una "Location" applicando un determinato rumore alla "userLocation".
func randomLocationInRadius(userLocation: CLLocationCoordinate2D,_ distribution: NoiseDistribution, radius: Double) -> Location {
    var deltaLocation : (Double, Double) = (0, 0)
    switch distribution {
    case .uniform:
        print("Uniform distribution")
        deltaLocation = uniformPointInDisk(radius: radius)
    case .poisson:
        print("Poisson distribution")
        deltaLocation = poissonPointInDisk(radius: radius, lam: 20, k: 1)
    case .triangular:
        print("Trinagular distribution")
        // deltaLocation = randomPointInDisk(radius: radius)
    case .gaussian:
        print("Gauss distribution")
        // deltaLocation = randomPointInDisk(radius: radius)
    }
    let latitude = userLocation.latitude + kilometersToDegreesLatitude(kilometers: deltaLocation.0)
    let longitude = userLocation.longitude + kilometersToDegreesLongitude(km: deltaLocation.1, latitude: latitude)
    return Location(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
}

func generateFakeLocations(_ location: CLLocationCoordinate2D,_ distribution: NoiseDistribution,_ dummiesRequested: Int) -> [Location] {
    // Number of dummies.
    let maxDummies = 20
    // List of random locations.
    var locations: [Location] = []
    
    //    Errore: dummiesRequested viene gestita come una variabile let e non possibile assegnarci valori
    //    if dummiesRequested > maxDummies {
    //        dummiesRequested = maxDummies
    //    }
    
    for _ in 0..<dummiesRequested {
        locations.append(randomLocationInRadius(userLocation: location, distribution, radius: 0.5))
    }
    
    return locations
}



struct testAPI_Previews: PreviewProvider {
    static var previews: some View {
        testLocation()
            .previewDevice("iPhone 13")
        
    }
}
