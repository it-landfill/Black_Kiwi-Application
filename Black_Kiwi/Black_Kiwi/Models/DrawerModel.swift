//
//  DrawerModel.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 04/10/22.
//

import Foundation
import SwiftUI

struct DrawerModel {
    enum heights: CGFloat {
        case peek = -5
        case low = 50
        case mid = 300
        case high = 600
    }
    
    static let defaultHeights: [CGFloat] = [heights.low.rawValue, heights.mid.rawValue, heights.high.rawValue]
    
    static func setHeight(restHeights: Binding<[CGFloat]>, height: heights, availHeights: [CGFloat] = defaultHeights) async {
        restHeights.wrappedValue = [height.rawValue]
        let seconds: Double = 1
        do {
            try await Task.sleep(nanoseconds: UInt64(seconds * Double(NSEC_PER_SEC)))
        }
        catch {
            print("Unexpected error in DrawModel.setHeight: \(error)")
        }
        if height == .peek {
            var tmpHeights = availHeights
            tmpHeights.append(heights.peek.rawValue)
            restHeights.wrappedValue = tmpHeights
        } else {
            restHeights.wrappedValue = availHeights
        }
    }
}
