//
//  DrawerContentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct DrawerContentView: View {
    
    @Binding var restHeights: [CGFloat]
    @Binding var POIInfo: POIModel.Item?
    @State private var openSettings: Bool = false
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(radius: 100)
            
            VStack {
                if openSettings {
                    DrawerSettingsView(openSettings: $openSettings, restHeights: $restHeights)
                } else if POIInfo != nil {
                    DrawerPOIInfo(poi: $POIInfo, restHeights: $restHeights)
                } else {
                    DrawerBaseComponent(openSettings: $openSettings, restHeights: $restHeights)
                }
                Spacer()
            }
            .border(.red)
            .padding(.all, 20)
            
            VStack(alignment: .center) {
                Spacer().frame(height: 4.0)
                RoundedRectangle(cornerRadius: 3.0)
                    .foregroundColor(.gray)
                    .frame(width: 30.0, height: 6.0)
                Spacer()
            }
        }
        .frame(height: UIScreen.main.bounds.height - 100)
    }
}

struct DrawerContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            VStack{
                Spacer()
                DrawerContentView(restHeights: .constant([30, 200, UIScreen.main.bounds.height - 200]), POIInfo: .constant(POIModel.Item.sampleData[2]))
            }
            .edgesIgnoringSafeArea(.bottom)
            .previewDevice("iPhone 13")
            
            VStack{
                Spacer()
                DrawerContentView(restHeights: .constant([30, 200, UIScreen.main.bounds.height - 200]), POIInfo: .constant(nil))
            }
            .edgesIgnoringSafeArea(.bottom)
            .previewDevice("iPhone 13")
        }
    }
}
