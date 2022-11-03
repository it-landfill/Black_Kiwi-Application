//
//  SearchView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 10/10/22.
//

import SwiftUI

struct SearchView: View {
    
    @State private var minRank: Float = 5
    @State private var poiCat: POIModel.CategoryTypes = POIModel.CategoryTypes.department
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var appSettings: AppSettings
    
    @Binding var showSheet: Bool
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet = false
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 40))
                            .padding(.trailing, 5)
                    }
                }
                Text("Point Of Interest category:")
                Picker("POI category", selection: $poiCat){
                    ForEach(POIModel.CategoryTypes.allCases, id: \.rawValue) {category in
                        Text(category.rawValue).tag(category)
                    }
                }
                Text("Min rank: " + (minRank == 0 ? "unlimited" : "\(minRank)"))
                Slider(value: $minRank, in: 0...10, step: 1)
                Button(action: {
                    showSheet = false
                    Task {
                        if let curLocs = locationManager.getCoordinatesWithNoise(dummyUpdateModel: appSettings.locationPrivacyModel) {
							if let trueLoc = locationManager.getCoordinates() {
                            let poiList = await DataManager.getReccomendations(dummyPositions: curLocs, truePosition: trueLoc, category: poiCat, minRank: Int(minRank), limit: nil)
                            if let poiList = poiList {
                                UIMapView.deletePOIs()
                                UIMapView.updatePOIs(POIList: poiList)
                            } else {
                                print("Unable to get POI list for search")
                            }
							} else {
                            print("Unable to get current location for search")
                        }
                        } else {
                            print("Unable to get current location for search")
                        }
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .frame(minHeight: 10, maxHeight: 50, alignment: .center)
                        Text("Search")
                            .font(.title)
                            .foregroundColor(Color.black)
                    }
                }
                .padding(.top, 20)
                Spacer()
            }
            .padding(30)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(showSheet: .constant(true))
    }
}
