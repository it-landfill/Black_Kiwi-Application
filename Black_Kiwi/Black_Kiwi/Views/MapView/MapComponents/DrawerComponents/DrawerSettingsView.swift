//
//  DrawerSettingsView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 02/10/22.
//

import SwiftUI

struct DrawerSettingsView: View {
    
    // TODO: Set default values for perturbation options
    // TODO: Apply button
    @Binding var openSettings: Bool
    @Binding var restHeights: [CGFloat]
    
    @State private var selectedPrivacyModel: Int = 0
    @State private var numberOfDummies: Float = 0
    @State private var perturbation: DummyUpdateModel.NoiseDistribution = .uniform
    @State private var radius: Float = 0.1
    
    // Poisson perturbation
    @State private var lambda: Double = 0.5
    
    // Gaussian perturbation
    @State private var mean: Double = 0
    @State private var standardDeviation: Double = 0.1
    
    // Triangular perturbation
    @State private var min: Double = 0
    @State private var max: Double = 0
    @State private var mode: Double = 0
    
    
    
    var body: some View {
        VStack {
            // Top bar text and icon
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
            
            NavigationView {
                List{
                    NavigationLink(destination: DrawerPrivacySettingsView()) {
                        Text("Privacy Settings")
                    }
                }
            }
            
            Spacer()
            
        }
        .task {
            await DrawerModel.setHeight(restHeights: $restHeights, height: DrawerModel.heights.high)
        }
    }
}

struct DrawerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSettingsView(openSettings: .constant(true), restHeights: .constant([100]))
    }
}
