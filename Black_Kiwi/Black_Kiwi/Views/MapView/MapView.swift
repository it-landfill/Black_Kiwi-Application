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
    
    var body: some View {
        ZStack {
            UIMapView()
                .edgesIgnoringSafeArea(.all)
            
            
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
                        
                        Button(action: {}){
                            Image(systemName: "location")
                                .foregroundColor(.gray)
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
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13")
    }
}
