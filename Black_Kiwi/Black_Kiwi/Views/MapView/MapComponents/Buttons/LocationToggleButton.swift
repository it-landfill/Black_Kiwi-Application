//
//  locationToggleButton.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 05/09/22.
//

import SwiftUI

struct LocationToggleButton: View {
    
    @Binding var locationStatus: Bool
    @Binding var showPermissionPopup: Bool
    
    var locationManager = LocationManager()
    
    var body: some View {
        Button(action: {
            locationStatus.toggle()
            if(locationStatus){
                showPermissionPopup = true
                locationManager.checkIfLocationServicesIsEnabled()
                UIMapView.startTrackingUser()
            } else {
                UIMapView.stopTrackingUser()
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
}

struct LocationToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationToggleButton(locationStatus: .constant(true), showPermissionPopup: .constant(false))
    }
}
