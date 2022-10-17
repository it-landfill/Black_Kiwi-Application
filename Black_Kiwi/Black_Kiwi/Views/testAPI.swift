//
//  testAPI.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/10/22.
//

import SwiftUI
import CoreLocation

struct testAPI: View {
    
    @State private var poiList: [POIModel.Item] = [POIModel.Item.sampleData[0], POIModel.Item.sampleData[1]]
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    poiList = await DataManager.getReccomendations(position: CLLocationCoordinate2D(), category: .department, minRank: 5, limit: 2) ?? [POIModel.Item.sampleData[0], POIModel.Item.sampleData[1]]
                }
            }, label: {
                    Text("Click me and check logs")
        })
            
            List(poiList) {
                Text($0.title ?? "---")
            }
        }
    }
}

struct testAPI_Previews: PreviewProvider {
    static var previews: some View {
        testAPI()
    }
}
