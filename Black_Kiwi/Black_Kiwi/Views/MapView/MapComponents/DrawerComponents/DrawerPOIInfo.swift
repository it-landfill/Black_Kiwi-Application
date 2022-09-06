//
//  DrawerPOIInfo.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 06/09/22.
//

import SwiftUI

struct DrawerPOIInfo: View {
    
    @Binding var poi: POIModel.Item?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(poi?.title ?? "TITLE")
                    .font(.title)
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
            HStack{
                VStack{
                    Text("Rank")
                        .bold()
                    Text("\(poi?.rank ?? 0, specifier: "%.1f")")
                }
                VStack{
                    Text("Distance")
                        .bold()
                    Text("\(poi?.distance ?? 0, specifier: "%.1f") Km")
                }
            }
            .font(.body)
            .padding(.top, 10)
        }
        
    }
}

struct DrawerPOIInfo_Previews: PreviewProvider {
    static var previews: some View {
        DrawerPOIInfo(poi: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
