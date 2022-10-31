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
    
    //private static let baseURL = "http://casadiale.noip.me:62950"
    private static let baseURL = "http://127.0.0.1:8080"

    struct responseCoordinates: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    struct responsePOI: Codable {
        let id: Int
        let name: String
        let category: String
        let rank: Int
        let coord: responseCoordinates
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
    
    static func getReccomendations(position: [CLLocationCoordinate2D], category: POIModel.CategoryTypes?, minRank: Int, limit: Int?) async -> [POIModel.Item]? {
        
        guard var url = URLComponents(string: "\(baseURL)/getRecommendation") else {
            print("Invalid URL")
            return nil
        }
        
        let rankStr = String(minRank)
        
        url.queryItems = [
            URLQueryItem(name: "minRank", value: rankStr),
        ]
        
        if let category = category {
            let catStr = category.rawValue
            print("Category: \(catStr)")
            url.queryItems?.append(URLQueryItem(name: "category", value: catStr))
        }
        
        if let limit = limit {
            let limitStr = String(limit)
            print("limit: \(limitStr)")
            url.queryItems?.append(URLQueryItem(name: "limit", value: limitStr))
        }
        
        
        if (position.count == 1) {
            // No privacy or single perturbation
            if let firstElem = position.first {
                let latStr = String(firstElem.latitude)
                let lonStr = String(firstElem.longitude)
                
                url.queryItems?.append(URLQueryItem(name: "latitude", value: latStr))
                url.queryItems?.append(URLQueryItem(name: "longitude", value: lonStr))
                print("New poi recommendation request. minRank: \(rankStr), lat: \(latStr), lon: \(lonStr).")
                
            }
        } else if (position.count > 1) {
            // TODO: Gestire il caso di dummy update
        } else {
            // TODO: Errore, nessuna location trovata
        }
        
        guard let composedURL = url.url else {
            print("Invalid generated URL")
            return nil
        }
        
        do {
            print("Trying to fetch data")
            let (data, _) = try await URLSession.shared.data(from: composedURL)
            if let decodedResponse = try? JSONDecoder().decode([responsePOI].self, from: data) {
                print(decodedResponse)
                var poiList: [POIModel.Item] = []
                for resp in decodedResponse {
                    poiList.append(responsePOItoPOIModel(response: resp))
                }
                return poiList
            } else {
                print("Unable to decode data")
                print(String(decoding: data, as: UTF8.self))
                return nil
            }
            
        } catch {
            print("Invalid data")
            return nil
        }
    }
}
