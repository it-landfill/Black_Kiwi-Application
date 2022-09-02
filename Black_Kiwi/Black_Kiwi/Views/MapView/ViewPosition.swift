//
//  ViewPosition.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 01/09/22.
//

import SwiftUI
import MapKit

struct ViewPosition: View {
    
    @State var showModal = false
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: .constant(MapModel.defaultMapRegion),
                showsUserLocation: true
            )
            Button(action: {
                showModal = true;
            }){
                Text("Locate")
            }
        }
        .JMAlert(showModal: $showModal, for: [.location], autoDismiss: true)
        .setPermissionComponent(for: .location, description: "Allow access to user location while using the app.")
    }
}

struct ViewPosition_Previews: PreviewProvider {
    static var previews: some View {
        ViewPosition()
    }
}
