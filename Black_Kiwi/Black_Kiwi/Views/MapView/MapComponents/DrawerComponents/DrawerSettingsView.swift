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
    
    @State private var selectedPrivacyModel: Int = 1
    @State private var numberOfDummies: Float = 0
    @State private var perturbation: DummyUpdateModel.NoiseDistribution = .triangular
    @State private var radius: Float = 0.1
    
    // Poisson perturbation
    @State private var lambda: Double = 0
    
    // Gaussian perturbation
    @State private var mean: Double = 0
    @State private var standardDeviation: Double = 50
    
    // Triangular perturbation
    @State private var min: Double = 0
    @State private var max: Double = 0
    @State private var mode: Double = 0
    
    
    
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
                Section("Privacy model") {
                    Picker("Privacy model", selection: $selectedPrivacyModel) {
                        Text("No location distorsion").tag(0)
                        Text("Location perturbation").tag(1)
                        Text("Dummy update").tag(2)
                    }
                }
                if (selectedPrivacyModel != 0) {
                    Section("Privacy model options"){
                        HStack {
                            Text("Dummies ")
                            Slider(value: $numberOfDummies, in: 0...10, step: 1)
                            Text("\(Int(numberOfDummies))")
                        }
                        Picker("Perturbation", selection: $perturbation) {
                            ForEach(DummyUpdateModel.NoiseDistribution.allCases, id: \.rawValue) { distribution in
                                Text(distribution.rawValue.capitalized).tag(distribution)
                            }
                        }
                        
                    }
                }
                if (selectedPrivacyModel != 0 && perturbation != .none){
                    Section("\(perturbation.rawValue) perturbation options"){
                        HStack {
                            Text("Radius ")
                            Slider(value: $radius, in: 0.1...2, step: 0.1)
                            if (radius<1) {
                                Text(String(format: "%.0f m", radius*1000))
                            } else {
                                Text(String(format: "%.1f Km", radius))
                            }
                        }
                        if (perturbation == .poisson) {
                            HStack{
                                Text("Lambda ")
                                Slider(value: $lambda, in: 10...20, step: 0.5)
                                Text(String(format: "%.1f", lambda))
                            }
                        }
                        if (perturbation == .gaussian) {
                            HStack{
                                Text("mean ")
                                Slider(value: $mean, in: 0...20, step: 0.5)
                                Text(String(format: "%.1f", mean))
                            }
                            HStack{
                                Text("sd ")
                                Slider(value: $standardDeviation, in: 40...60, step: 0.5)
                                Text(String(format: "%.1f", standardDeviation))
                            }
                        }
                        if (perturbation == .triangular) {
                            HStack{
                                Text("min ")
                                Slider(value: $min, in: 0...20, step: 1)
                                Text(String(format: "%.0f", min))
                            }
                            HStack{
                                Text("max ")
                                Slider(value: $max, in: 200...300, step: 1)
                                Text(String(format: "%.0f", max))
                            }
                            HStack{
                                Text("mode ")
                                Slider(value: &mode, in: 100...200, step: 1)
                                Text(String(format: "%.0f", mode))
                            }
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
