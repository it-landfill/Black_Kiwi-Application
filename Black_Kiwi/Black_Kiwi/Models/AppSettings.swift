//
//  AppSettings.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation

class AppSettings: ObservableObject {
	var locationPrivacyModel: DummyUpdateModel
    
    init() {
        self.locationPrivacyModel = DummyUpdateModel()
    }
    init(locationPrivacyModel: DummyUpdateModel) {
        self.locationPrivacyModel = locationPrivacyModel
    }
}
