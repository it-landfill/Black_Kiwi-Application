//
//  DrawerPOIInfo.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 06/09/22.
//

import SwiftUI

struct DrawerPOIInfo: View {
    
    @Binding var poi: POIModel.Item?
    @Binding var restHeights: [CGFloat]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(poi?.title ?? "TITLE")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    poi = nil
                }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            Text(poi?.categoryStruct.name ?? "Category")
                .font(.caption)
            Divider()
            HStack{
                VStack{
                    Text("Rank")
                        .bold()
                    Text("\(poi?.rank ?? 0, specifier: "%.1f")")
                }
                Spacer()
                VStack{
                    Text("Distance")
                        .bold()
                    Text(poi?.getDistance(position: LocationManager.getLocation()) ?? "--- Km")
                }
            }
            .font(.body)
            .padding(.top, 10)
            .padding(.horizontal,20)
            Divider()
        }
        .onAppear(perform: {
            restHeights = [200]
        })
        
    }
}

struct DrawerPOIInfo_Previews: PreviewProvider {
    static var previews: some View {
        DrawerPOIInfo(poi: .constant(nil), restHeights: .constant([200]))
            .previewLayout(.sizeThatFits)
    }
}
