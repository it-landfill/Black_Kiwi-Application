//
//  ListElementView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct ListElementView: View {
    
    @Binding var POI: POIModel.Item
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: POI.categoryStruct.icon)
                    .font(.title)
                    .padding(.horizontal, 25)
                Text(POI.categoryStruct.name.replacingOccurrences(of: " ", with: "\n"))
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            VStack {
                Text(POI.name)
                    .font(.headline)
                .multilineTextAlignment(.center)
            Text("rank: \(POI.rank, specifier: "%.1f")")
                .multilineTextAlignment(.center)
                .font(.caption)
            }
            Spacer()
                Text("\(POI.distance, specifier: "%.1f") Km")
                    .multilineTextAlignment(.trailing)
        }
    }
}

struct ListElementView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListElementView(POI: .constant(POIModel.Item.sampleData[0]))
            ListElementView(POI: .constant(POIModel.Item.sampleData[2]))
            ListElementView(POI: .constant(POIModel.Item.sampleData[4]))
            ListElementView(POI: .constant(POIModel.Item.sampleData[6]))
            ListElementView(POI: .constant(POIModel.Item.sampleData[8]))
        }
        .previewLayout(.sizeThatFits)
    }
}
