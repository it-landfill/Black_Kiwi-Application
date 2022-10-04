//
//  DrawerSettingsView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 02/10/22.
//

import SwiftUI

struct DrawerSettingsView: View {
    
    @Binding var openSettings: Bool
    @Binding var restHeights: [CGFloat]
    
    @State private var selectedPrivacyModel: LocationManager.PrivacyModels = LocationManager.PrivacyModels.none
    @State private var privacyModelOptions: Int = 0
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        openSettings = false
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title)
                    }
                }
            }
            
            List{
                Section("Privacy options") {
                    Picker("Privacy model", selection: $selectedPrivacyModel) {
                        ForEach(LocationManager.PrivacyModels.allCases, id: \.rawValue) {model in
                            Text(model.rawValue).tag(model)
                        }
                    }
                    Text(LocationManager.getPrivacyModelInfo(selectedPrivacyModel).description)
                    if(selectedPrivacyModel == LocationManager.PrivacyModels.B) {
                        Picker("Model settings", selection: $privacyModelOptions){
                            Text("Option 1").tag(0)
                            Text("Option 2").tag(1)
                            Text("Option 3").tag(2)
                        }
                    }
                }
            }
        }
        Spacer()
            .task {
                await DrawerModel.setHeight(restHeights: $restHeights, height: DrawerModel.heights.mid)
            }
    }
}

struct DrawerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSettingsView(openSettings: .constant(true), restHeights: .constant([100]))
    }
}
