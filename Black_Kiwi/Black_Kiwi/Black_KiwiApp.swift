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
    
    var body: some Scene {
        WindowGroup {
            if authenticationStatus != .authenticated {
                LoginView(authenticationStatus: $authenticationStatus)
            } else {
                MainView()
            }
                
            // testLocation()
        }
    }
}
