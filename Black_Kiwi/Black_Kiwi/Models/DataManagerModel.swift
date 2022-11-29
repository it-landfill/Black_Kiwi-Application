//
//  DataManagerModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/10/22.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftUI

class DataManager {
    
    struct responseCoordinates: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    struct responsePOI: Codable {
        let id: Int
        let name: String
        let category: String
        let rank: Float
        let coord: responseCoordinates
    }
    
    struct requestData: Codable {
        let minRank: Float
        let category: POIModel.CategoryTypes?
        let limit: Int?
        let latitude: Double
        let longitude: Double
    }
    
    static func responsePOItoPOIModel(response: responsePOI) -> POIModel.Item {
        let category: POIModel.CategoryTypes
        switch(response.category){ //TODO: Refactor this switch, remove it?
        case "Department":
            category = .department
        case "Historical Building":
            category = .historical_building
        case "Museum":
            category = .museum
        case "Park":
            category = .park
        case "Theater":
            category = .theater
        default:
            print("[ERROR] Unable to decode category \(response.category). reverting to default")
            category = .department
        }
        
        return POIModel.Item(name: response.name, category: category, coordinate: CLLocationCoordinate2D(latitude: response.coord.latitude, longitude: response.coord.longitude), rank: 1)
    }
    
    static func getReccomendations(apiToken: String, dummyPositions: [CLLocationCoordinate2D], truePosition: CLLocationCoordinate2D, category: POIModel.CategoryTypes?, minRank: Float, limit: Int?) async -> [POIModel.Item]? {
        
        let endpoint = "\(AppSettings.apiURL)/mobile/getRecommendation"
        
        var dummyPositions = dummyPositions;
        var poiList: [POIModel.Item] = []
        
        // Index of the true location, if we have less than 2 dummy locations, the element will be the true location
        var truePosIndex: Int = 0;
        
        // If the dummy position list has more than 1 dummy, replace a random one with the real location and save the index in truePosIndex
        if dummyPositions.count > 1 {
            truePosIndex = Int.random(in: 1..<dummyPositions.count)
            dummyPositions[truePosIndex] = truePosition
        }
        
        let headers: HTTPHeaders = [
            "X-API-KEY": apiToken
        ]
        
        // Loop each location and request POI to the server
        // for (index: Int, item: CLLocationCoordinate2D) in dummyPositions.enumerated() {
        for  index in 0 ..< dummyPositions.count {
            let item = dummyPositions[index]
            
            let params = requestData(minRank: minRank, category: category, limit: limit, latitude: item.latitude, longitude: item.longitude)
            let dataTask = AF.request(endpoint, method: .get, parameters: params, headers: headers).serializingDecodable([responsePOI].self)
            
            let response = await dataTask.response
            
            if index == truePosIndex {
                if (response.error != nil) {
                    print("Error in getRecommendation")
                    debugPrint(response)
                    return nil
                }
                
                print("True pos received, decoding.")
                if let response = response.value {
                    print("Resp")
                    print(response)
                    for resp: DataManager.responsePOI in response {
                        print(resp)
                        poiList.append(responsePOItoPOIModel(response: resp))
                    }
                }
                
                
            } else {
                print("Dummy received, ignoring.")
            }
        }
        
        print("POI List:")
        print(poiList)
        return poiList
    }
}
