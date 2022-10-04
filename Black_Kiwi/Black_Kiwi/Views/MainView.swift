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
    
    @State private var restHeights = DrawerModel.defaultHeights
    @State private var selectedPOI: POIModel.Item? = nil
    
    var body: some View {
        ZStack {
            MapView(selectedPOI: $selectedPOI)
            Drawer {
                DrawerContentView(restHeights: $restHeights, POIInfo: $selectedPOI)
            }
            .rest(at: $restHeights)
        }
        .environmentObject(locationManager)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
