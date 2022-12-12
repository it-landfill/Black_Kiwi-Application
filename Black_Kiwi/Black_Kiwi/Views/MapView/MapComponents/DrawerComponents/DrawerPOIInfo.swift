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
    
    @EnvironmentObject private var locationManager: LocationManager
    
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
                    Text("\(poi?.rank ?? 0, specifier: "%.0f")")
                }
                Spacer()
                VStack{
                    Text("Distance")
                        .bold()
                    Text(poi?.getDistance(position: locationManager.getLocation()) ?? "--- Km")
                }
            }
            .font(.body)
            .padding(.top, 10)
            .padding(.horizontal,20)
            Divider()
        }
        .task {
            await DrawerModel.setHeight(restHeights: $restHeights, height: DrawerModel.heights.mid)
        }
        
    }
}

struct DrawerPOIInfo_Previews: PreviewProvider {
    static var previews: some View {
        DrawerPOIInfo(poi: .constant(nil), restHeights: .constant([200]))
            .previewLayout(.sizeThatFits)
    }
}
