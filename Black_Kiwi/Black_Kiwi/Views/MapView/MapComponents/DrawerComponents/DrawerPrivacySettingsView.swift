//
//  DrawerPrivacySettingsView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 31/10/22.
//

import SwiftUI

struct DrawerPrivacySettingsView: View {
    
    @State private var selectedPrivacyModel: Int = 0
    @State private var numberOfDummies: Float = 2
    @State private var perturbation: DummyUpdateModel.NoiseDistribution = .uniform
    @State private var radius: Double = 0.1
    
    // Poisson perturbation
    @State private var lambda: Double = 0.5
    
    // Gaussian perturbation
    @State private var mean: Double = 0
    @State private var standardDeviation: Double = 0.1
    
    // Triangular perturbation
    @State private var min: Double = 0
    @State private var max: Double = 0
    @State private var mode: Double = 0
        
    @EnvironmentObject private var appSettings: AppSettings
    
    var body: some View {
        VStack {
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
                        if (selectedPrivacyModel == 2) {
                            HStack {
                                Text("Dummies ")
                                Slider(value: $numberOfDummies, in: 2...10, step: 1)
                                Text("\(Int(numberOfDummies))")
                            }
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
                            Slider(value: $radius, in: 0.1...4.1, step: 0.1)
                            if (radius<1) {
                                Text(String(format: "%.0f m", radius*1000))
                            } else {
                                Text(String(format: "%.1f Km", radius))
                            }
                        }
                        // Parametri gaussian distribution:
                        // lambda:  min = 0.5 e max = 10 con passo 0.5
                        if (perturbation == .poisson) {
                            HStack{
                                Text("Lambda ")
                                Slider(value: $lambda, in: 0.5...10, step: 0.5)
                                Text(String(format: "%.1f", lambda))
                            }
                        }
                        // Parametri gaussian distribution:
                        // mean:                min = 0 e max = 2 con passo 0.1
                        // standard_deviation:  min = 0.1 e max = 2 con passo 0.1
                        if (perturbation == .gaussian) {
                            HStack{
                                Text("mean ")
                                Slider(value: $mean, in: 0...2, step: 0.1)
                                Text(String(format: "%.1f", mean))
                            }
                            HStack{
                                Text("sd ")
                                Slider(value: $standardDeviation, in: 0.1...2, step: 0.1)
                                Text(String(format: "%.1f", standardDeviation))
                            }
                        }
                        // Parametri triangular distribution:
                        // min:     min = 0 e max = 2 con passo 0.2
                        // max:     min = 0 e max = 4 con passo 0.2
                        // mode:    min = 0 e max = 4 con passo 0.2
                        if (perturbation == .triangular) {
                            HStack{
                                Text("min ")
                                Slider(value: $min, in: 0...2, step: 0.2)
                                Text(String(format: "%.1f", min))
                            }
                            HStack{
                                Text("max ")
                                Slider(value: $max, in: 0...4, step: 0.2)
                                Text(String(format: "%.1f", max))
                            }
                            HStack{
                                Text("mode ")
                                Slider(value: $mode, in: 0...4, step: 0.2)
                                Text(String(format: "%.1f", mode))
                            }
                        }
                    }
                }
                NavigationLink(destination: {
                    TestPrivacyLocation(selectedPrivacyModel: $selectedPrivacyModel, numberOfDummies: $numberOfDummies, perturbation: $perturbation, radius: $radius, lambda: $lambda, mean: $mean, standardDeviation: $standardDeviation, min: $min, max: $max, mode: $mode)
                }, label: {
                    Text("Test Configuration")
                })
                Button(action: {
                    if selectedPrivacyModel == 1 {
                        numberOfDummies = 1
                    }
                    
                    let dummyUpdateModel = DummyUpdateModel(radius: radius, numberOfDummies: Int(numberOfDummies), noiseDistribution: perturbation, lambda: lambda, min: min, max: max, mode: mode, mean: mean, standard_deviation: standardDeviation)
                    appSettings.locationPrivacyModel = dummyUpdateModel
                }, label: {
                    Text("Apply")
                })
            }
        }
        Spacer()
            .onAppear(perform: {
                let dummyUpdateModel = appSettings.locationPrivacyModel
                
                radius = dummyUpdateModel.radius
                numberOfDummies = Float(dummyUpdateModel.numberOfDummies)
                
                perturbation = dummyUpdateModel.noiseDistribution
                lambda = dummyUpdateModel.lambda
                min = dummyUpdateModel.min
                max = dummyUpdateModel.max
                mode = dummyUpdateModel.mode
                mean = dummyUpdateModel.mean
                standardDeviation = dummyUpdateModel.standard_deviation
                
                if (perturbation == .none) {
                    selectedPrivacyModel = 0
                } else if (numberOfDummies == 1) {
                    selectedPrivacyModel = 1
                } else {
                    selectedPrivacyModel = 2
                }
            })
    }
}

struct DrawerPrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerPrivacySettingsView()
            .environmentObject(AppSettings())
    }
}
