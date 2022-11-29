//
//  AppSettings.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation

class AppSettings: ObservableObject {
	var locationPrivacyModel: DummyUpdateModel
    var apiToken: String
    
    init() {
        self.locationPrivacyModel = DummyUpdateModel()
        self.apiToken = ""
    }
    init(locationPrivacyModel: DummyUpdateModel) {
        self.locationPrivacyModel = locationPrivacyModel
        self.apiToken = ""
    }
    init(locationPrivacyModel: DummyUpdateModel, apiToken: String) {
        self.locationPrivacyModel = locationPrivacyModel
        self.apiToken = apiToken
    }
}

extension AppSettings {
    //static var apiURL: String = "http://casadiale.noip.me:62950"
    static var apiURL: String = "http://127.0.0.1:8080"
}
