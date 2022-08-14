//
//  DrawerContentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct DrawerContentView: View {
    
    @Binding var restHeights: [CGFloat]
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(radius: 100)
            
            VStack{
                SearchBarComponentView(restHeights: $restHeights)
                Spacer()
            }
            .padding(.top, 20)
            
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
        VStack{
            Spacer()
            DrawerContentView(restHeights: .constant([30, 200, UIScreen.main.bounds.height - 200]))
        }
        .edgesIgnoringSafeArea(.bottom)
        .previewDevice("iPhone 13")
    }
}
