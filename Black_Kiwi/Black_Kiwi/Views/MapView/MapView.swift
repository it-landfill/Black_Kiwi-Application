//
//  MapView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI
import MapKit
import Drawer

struct MapView: View {
    
    @State private var restHeights = [30, 200, UIScreen.main.bounds.height - 200]
    @State private var POIList: [POIModel.Item] = POIModel.Item.sampleData
    @State private var showPermissionPopup = false
    @State private var locationStatus = false
    
    private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            UIMapView()
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    //uiMapView.updatePOIs(POIList: POIList)
                })
            
            
            //Button components
            //TODO: Move to component view
            VStack{
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {}){
                            Image(systemName: "map.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(13)
                        
                        Button(action: {
                            locationStatus = !locationStatus
                            if(locationStatus){
                                showPermissionPopup = true
                                locationManager.checkIfLocationServicesIsEnabled()
                                LocationManager.startUpdatingLocation()
                                if let location = LocationManager.getLocation() {
                                    print("Setting location")
                                    UIMapView.centerOnPoint(point: location)
                                }
                            }
                        }){
                            if (locationStatus) {
                                Image(systemName: "location")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "location")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(13)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 55)
                    .padding(.trailing,3)
                }
                Spacer()
                
            }
            
            Drawer {
                DrawerContentView(restHeights: $restHeights)
            }
            .rest(at: $restHeights)
            
        }
        .JMAlert(showModal: $showPermissionPopup, for: [.location], autoDismiss: true)
        .setPermissionComponent(for: .location, description: "Allow access to user location while using the app.")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13")
    }
}
