//
//  MapTypeView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 05/09/22.
//

import SwiftUI

struct MapTypeButton: View {
    var body: some View {
        Button(action: {}){
            Image(systemName: "map.fill")
                .foregroundColor(.gray)
        }
        .padding(13)
    }
}

struct MapTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        MapTypeButton()
            .previewLayout(.sizeThatFits)
    }
}
