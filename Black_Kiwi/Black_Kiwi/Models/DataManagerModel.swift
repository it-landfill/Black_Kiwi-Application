//
//  DataManagerModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/10/22.
//

import Foundation
import CoreLocation
import SwiftUI

class DataManager {
    
    private static let baseURL = "http://casadiale.noip.me:62950"
    
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
    
    static func responsePOItoPOIModel(response: responsePOI) -> POIModel.Item {
        let category: POIModel.CategoryTypes
        switch(response.category){ //TODO: Refactor this switch, remove it?
        case "department":
            category = .department
        case "historical building":
            category = .historical_building
        case "museum":
            category = .museum
        case "park":
            category = .park
        case "theater":
            category = .theater
        default:
            category = .department
        }
        
        return POIModel.Item(name: response.name, category: category, coordinate: CLLocationCoordinate2D(latitude: response.coord.latitude, longitude: response.coord.longitude), rank: 1.2)
    }
    
    static func getReccomendations(position: CLLocationCoordinate2D, category: POIModel.CategoryTypes?, minRank: Int, limit: Int?) async -> [POIModel.Item]? {
        guard let url = URL(string: "\(baseURL)/getRecommendation?category=department&minRank=0&limit=5&latitude=11.343083381652832&longitude=44.49433189374523") else {
            print("Invalid URL")
            return nil
        }
        do {
            print("Trying to fetch data")
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([responsePOI].self, from: data) {
                print(decodedResponse)
                var poiList: [POIModel.Item] = []
                for resp in decodedResponse {
                    poiList.append(responsePOItoPOIModel(response: resp))
                }
                return poiList
            } else {
                print("Unable to decode data")
                print(data)
                return nil
            }
            
        } catch {
            print("Invalid data")
            return nil
        }
    }
}
