//
//  Black_KiwiApp.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

@main
struct Black_KiwiApp: App {
    @StateObject var appSettings: AppSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            if appSettings.authenticationStatus != .authenticated {
                LoginView()
                    .environmentObject(appSettings)
            } else {
                MainView()
                    .environmentObject(appSettings)
            }
            
            //testLocation()
        }
    }
}
