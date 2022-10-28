//
//  AppSettings.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 28/10/22.
//

import Foundation

class AppSettings: ObservableObject {
	let LocationPrivacyModel: DummyUpdateModel
    
    init() {
        self.LocationPrivacyModel = DummyUpdateModel()
    }
    init(LocationPrivacyModel: DummyUpdateModel) {
        self.LocationPrivacyModel = LocationPrivacyModel
    }
}
