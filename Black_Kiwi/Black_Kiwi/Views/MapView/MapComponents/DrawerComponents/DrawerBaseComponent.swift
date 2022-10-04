//
//  DrawerBaseComponent.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 06/09/22.
//

import SwiftUI

struct DrawerBaseComponent: View {
    
    @Binding var openSettings: Bool
    @Binding var restHeights: [CGFloat]
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                Button(action: {
                    openSettings = true
                }){
                    Image(systemName: "gear.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            WIPView(newContent: "Base drawer tab")
        }
        .onAppear(perform: {
            restHeights = [30, 200, UIScreen.main.bounds.height - 200]
        })
    }
}

struct DrawerBaseComponent_Previews: PreviewProvider {
    static var previews: some View {
        DrawerBaseComponent(openSettings: .constant(false), restHeights: .constant([200]))
            .previewLayout(.sizeThatFits)
    }
}
