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
    // private static let baseURL = "http://127.0.0.1:8080"
    
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
    
    static func getReccomendations(dummyPositions: [CLLocationCoordinate2D], truePosition: CLLocationCoordinate2D, category: POIModel.CategoryTypes?, minRank: Int, limit: Int?) async -> [POIModel.Item]? {
        
        var dummyPositions = dummyPositions;
        
        guard var baseURL: URLComponents = URLComponents(string: "\(baseURL)/getRecommendation") else {
            print("Invalid URL")
            return nil
        }
        
		// Prepare the rank request
        let rankStr: String = String(minRank)
        baseURL.queryItems = [
            URLQueryItem(name: "minRank", value: rankStr),
        ]
        
		// Prepare the category request
        if let category = category {
            let catStr = category.rawValue
            print("Category: \(catStr)")
            baseURL.queryItems?.append(URLQueryItem(name: "category", value: catStr))
        }
        
		// Prepare the limit request
        if let limit: Int = limit {
            let limitStr: String = String(limit)
            print("limit: \(limitStr)")
            baseURL.queryItems?.append(URLQueryItem(name: "limit", value: limitStr))
        }
        
		// Initializa the return POI list
        var poiList: [POIModel.Item] = []
		// Index of the true location, if we have less than 2 dummy locations, the element will be the true location
        var truePosIndex: Int = 0;

		// If the dummy position list has more than 1 dummy, replace a random one with the real location and save the index in truePosIndex
        if dummyPositions.count > 1 {
            truePosIndex = Int.random(in: 1..<dummyPositions.count)
            dummyPositions[truePosIndex] = truePosition
		}
        
		// Loop each location and request POI to the server
        // for (index: Int, item: CLLocationCoordinate2D) in dummyPositions.enumerated() {
        for  index in 0 ..< dummyPositions.count {
            let item = dummyPositions[index]
            // Compose the URL with the current location element
            var url: URLComponents = baseURL
            let latStr: String = String(item.latitude)
            let lonStr: String = String(item.longitude)
            url.queryItems?.append(URLQueryItem(name: "latitude", value: latStr))
            url.queryItems?.append(URLQueryItem(name: "longitude", value: lonStr))
            
            // Try to generate the full URL
            guard let composedURL: URL = url.url else {
                print("Invalid generated URL")
                continue
            }
            
            print(composedURL) //TODO: Remove, check that the URL is correct
            
            do {
                print("Trying to fetch data")
                let (data, _) = try await URLSession.shared.data(from: composedURL)
                // Parse the data only if the index is the one containing the true user position
                if index == truePosIndex {
                    print("True pos received, decoding.")
                    if let decodedResponse: [DataManager.responsePOI] = try? JSONDecoder().decode([responsePOI].self, from: data) {
                        print(decodedResponse)
                        for resp: DataManager.responsePOI in decodedResponse {
                            poiList.append(responsePOItoPOIModel(response: resp))
                        }
                    } else {
                        print("Unable to decode data")
                        print(String(decoding: data, as: UTF8.self))
                        continue
                    }
                } else {
                    print("Dummy received, ignoring.")
                }
            } catch {
                print("Invalid data")
                continue
            }
        }
        
        return poiList
    }
}
