//
//  POIModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct POIModel {
    struct Category: Identifiable {
        let id: Int
        let name: String
        let type: CategoryTypes
        let color: Color
        let icon: String
    }
    
    enum CategoryTypes: String, Codable, CaseIterable {
        case historical_building = "Historical Building"
        case park = "Park"
        case theater = "Theater"
        case museum = "Museum"
        case department = "Department"
    }
    
    class Item: NSObject, Identifiable, MKAnnotation {
        let id: UUID //TODO: Allineare con ID backend
        var title: String?
        var category: CategoryTypes
        var coordinate: CLLocationCoordinate2D
        var rank: Float
        
        init(
            name: String,
            category: CategoryTypes,
            coordinate: CLLocationCoordinate2D,
            rank: Float
        ){
            self.id = UUID()
            self.title = name
            self.category = category
            self.coordinate = coordinate
            self.rank = rank
            
            super.init()
        }
        
        func getDistance(position: CLLocation?) -> String {
            if let position = position {
                let dist: Double = position.distance(from: CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude))
                if dist>1000 {
                    return "\(String(format: "%.2f", dist/1000)) Km"
                } else {
                    return "\(String(format: "%.2f", dist)) m"
                }
            } else {
                return "--- Km"
            }
        }
    }
}

extension POIModel.Item {
    static let sampleData: [POIModel.Item] = [
        POIModel.Item(name: "Dip di Ingegneria Lazzaretto", category: POIModel.CategoryTypes.department, coordinate: CLLocationCoordinate2D(latitude: 44.51254340585983, longitude: 11.320724487304686), rank: 50),
        POIModel.Item(name: "Dip di Ingegneria", category: POIModel.CategoryTypes.department, coordinate: CLLocationCoordinate2D(latitude: 44.48836217722139, longitude: 11.329221725463867), rank: 60),
        
        POIModel.Item(name: "Giardini Margherita", category: POIModel.CategoryTypes.park, coordinate: CLLocationCoordinate2D(latitude: 44.482177518841205, longitude: 11.353597640991211), rank: 40),
        POIModel.Item(name: "Villa Angeletti", category: POIModel.CategoryTypes.park, coordinate: CLLocationCoordinate2D(latitude: 44.51180893396823, longitude: 11.332569122314453), rank: 70),
        
        POIModel.Item(name: "Teatro di Villa Aldrovandi", category: POIModel.CategoryTypes.theater, coordinate: CLLocationCoordinate2D(latitude: 44.46937748011179, longitude: 11.369948387145996), rank: 30),
        POIModel.Item(name: "Teatro Europa", category: POIModel.CategoryTypes.theater, coordinate: CLLocationCoordinate2D(latitude: 44.5113804877569, longitude: 11.363210678100586), rank : 80),
        
        POIModel.Item(name: "Palazzo Re Enzo", category: POIModel.CategoryTypes.historical_building, coordinate: CLLocationCoordinate2D(latitude: 44.49433189374523, longitude: 11.343083381652832), rank: 20),
        POIModel.Item(name: "Chiesa di Santo Stefano", category: POIModel.CategoryTypes.historical_building, coordinate: CLLocationCoordinate2D(latitude: 44.491607329696045, longitude: 11.34913444519043), rank: 90),
        
        POIModel.Item(name: "Museo di Ustica", category: POIModel.CategoryTypes.museum, coordinate: CLLocationCoordinate2D(latitude: 44.5131707599374, longitude: 11.35037899017334), rank: 10),
        POIModel.Item(name: "Museo Medievale", category: POIModel.CategoryTypes.museum, coordinate: CLLocationCoordinate2D(latitude: 44.49613799525846, longitude: 11.341838836669922), rank: 100)
    ]
}

extension POIModel.Item {
    var categoryStruct: POIModel.Category {
        switch category{
        case POIModel.CategoryTypes.historical_building:
            return POIModel.categoriesStructs[0]
        case POIModel.CategoryTypes.park:
            return POIModel.categoriesStructs[1]
        case POIModel.CategoryTypes.theater:
            return POIModel.categoriesStructs[2]
        case POIModel.CategoryTypes.museum:
            return POIModel.categoriesStructs[3]
        case POIModel.CategoryTypes.department:
            return POIModel.categoriesStructs[4]
        }
    }
}

extension POIModel {
    static let categoriesStructs: [POIModel.Category] = [
        Category(id: 0, name: "Historical Building", type: POIModel.CategoryTypes.historical_building, color: Color.purple, icon: "building.columns.circle.fill"),
        Category(id: 1, name: "Park",  type: POIModel.CategoryTypes.park, color: Color.green, icon: "leaf.circle.fill"),
        Category(id: 2, name: "Theater",  type: POIModel.CategoryTypes.theater, color: Color.red, icon: "theatermasks.circle.fill"),
        Category(id: 3, name: "Museum",  type: POIModel.CategoryTypes.museum, color: Color.blue, icon: "building.2.crop.circle.fill"),
        Category(id: 4, name: "Department",  type: POIModel.CategoryTypes.department, color: Color.black, icon: "book.circle.fill")
    ]
}
