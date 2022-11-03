//
//  Black_KiwiApp.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

@main
struct Black_KiwiApp: App {
    @State private var ajeje = LoginView.AuthenticationStatus.notAuthenticated
    
    var body: some Scene {
        WindowGroup {
            //MainView()
            // testLocation()
            LoginView(authenticationStatus: $ajeje)
        }
    }
}
