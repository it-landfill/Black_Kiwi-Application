//
//  Black_KiwiApp.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

@main
struct Black_KiwiApp: App {
    @State private var authenticationStatus = LoginManagerModel.AuthenticationStatus.notAuthenticated
    @StateObject var appSettings: AppSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            if authenticationStatus != .authenticated {
                LoginView(authenticationStatus: $authenticationStatus)
                    .environmentObject(appSettings)
            } else {
                MainView()
                    .environmentObject(appSettings)
            }
            
            //testLocation()
        }
    }
}
