//
//  AppSettings.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    var locationPrivacyModel: DummyUpdateModel
    var apiToken: String
    @Published var authenticationStatus: LoginManagerModel.AuthenticationStatus
    
    init() {
        self.locationPrivacyModel = DummyUpdateModel()
        self.apiToken = ""
        self.authenticationStatus = (ProcessInfo.processInfo.environment["noauth"] != nil ? .authenticated : .notAuthenticated)
    }
    init(locationPrivacyModel: DummyUpdateModel) {
        self.locationPrivacyModel = locationPrivacyModel
        self.apiToken = ""
        self.authenticationStatus = (ProcessInfo.processInfo.environment["noauth"] != nil ? .authenticated : .notAuthenticated)
    }
    init(locationPrivacyModel: DummyUpdateModel, apiToken: String) {
        self.locationPrivacyModel = locationPrivacyModel
        self.apiToken = apiToken
        self.authenticationStatus = .authenticated
    }
}

extension AppSettings {
    static var apiURL: String = (ProcessInfo.processInfo.environment["host"] != nil ? ProcessInfo.processInfo.environment["host"]! : "http://casadiale.noip.me:62950")
}
