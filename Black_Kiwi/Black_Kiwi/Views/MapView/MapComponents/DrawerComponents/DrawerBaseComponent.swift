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
    @State private var showingSearchSheet = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingSearchSheet = true
                }){
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .frame(minHeight: 10, maxHeight: 50, alignment: .center)
                        Text("Search POI")
                            .font(.title)
                            .foregroundColor(Color.black)
                    }
                    .padding([.leading, .vertical],10)
                }
                Spacer()
                Button(action: {
                    openSettings = true
                }){
                    Image(systemName: "gear.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 40))
                        .padding(.trailing, 5)
                }
            }
            WIPView(newContent: "Base drawer tab")
        }
        .task {
            await DrawerModel.setHeight(restHeights: $restHeights, height: DrawerModel.heights.low)
        }
        .sheet(isPresented: $showingSearchSheet, content: {
            if #available(iOS 16.0, *) {
                SearchView(showSheet: $showingSearchSheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                SearchView(showSheet: $showingSearchSheet)
            }
        })
        
    }
}

struct DrawerBaseComponent_Previews: PreviewProvider {
    static var previews: some View {
        DrawerBaseComponent(openSettings: .constant(false), restHeights: .constant([200]))
            .previewLayout(.sizeThatFits)
    }
}
