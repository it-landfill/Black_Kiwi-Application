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
    @State private var showRestrictedAccessAlert = false
    @State private var showDeniedAccessAlert = false
    @State private var selectedPOI: POIModel.Item? = nil
    
    var body: some View {
        ZStack {
            UIMapView()
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    UIMapView.updatePOIs(POIList: POIList)
                    UIMapView.selectedPOI = $selectedPOI
                    LocationManager.showDeniedAccessAlert = $showDeniedAccessAlert
                    LocationManager.showRestrictedAccessAlert = $showRestrictedAccessAlert
                    LocationManager.locationStatus = $locationStatus
                })
            
            
            //Button components
            VStack{
                HStack {
                    Spacer()
                    VStack {
                        MapTypeButton()
                        LocationToggleButton(locationStatus: $locationStatus, showPermissionPopup: $showPermissionPopup)
                        if (locationStatus) {
                            LocationModeButton()
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 55)
                    .padding(.trailing,3)
                }
                Spacer()
                
            }
            
            Drawer {
                DrawerContentView(restHeights: $restHeights, POIInfo: $selectedPOI)
            }
            .rest(at: $restHeights)
            
        }
        .JMAlert(showModal: $showPermissionPopup, for: [.location], autoDismiss: true)
        .setPermissionComponent(for: .location, description: "Allow access to user location while using the app.")
        .alert("Location Warning", isPresented: $showRestrictedAccessAlert, actions: {}, message: {Text("Location access is restricted")})
        .alert("Location Error", isPresented: $showDeniedAccessAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
            Button("Open Settings", role: nil, action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })
        }, message: {Text("Location access has been denied. Please go to system settings and allow access to location while using.")})
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13")
    }
}
