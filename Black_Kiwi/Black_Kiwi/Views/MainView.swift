//
//  MainView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 04/10/22.
//

import SwiftUI
import Drawer

struct MainView: View {
    
    @StateObject var locationManager: LocationManager = LocationManager()
    // App settings is declared in Black_KiwiApp
    
    @State private var restHeights = DrawerModel.defaultHeights
    @State private var selectedPOI: POIModel.Item? = nil
    
    var body: some View {
        ZStack {
            MapView(selectedPOI: $selectedPOI)
            HStack {
                Drawer {
                    DrawerContentView(restHeights: $restHeights, POIInfo: $selectedPOI)
                }
                .rest(at: $restHeights)
                .frame(maxWidth: 400)
                Spacer()
            }
            .padding(.leading,10)
        }
        .environmentObject(locationManager)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
