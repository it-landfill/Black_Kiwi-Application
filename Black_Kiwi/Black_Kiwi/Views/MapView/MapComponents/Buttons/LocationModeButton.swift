//
//  LocationModeButton.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 05/09/22.
//

import SwiftUI

struct LocationModeButton: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        
        Button(action: {
           if let location = locationManager.getCoordinates() {
               print("Centering on location")
               UIMapView.centerOnPoint(point: location)
            }
        }){
            Image(systemName: "location.fill.viewfinder")
                .foregroundColor(.gray)
        }
        .padding(13)
    }
}

struct LocationModeButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationModeButton()
    }
}
