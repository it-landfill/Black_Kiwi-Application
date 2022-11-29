//
//  WIPView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct WIPView: View {
    
    var newContent : String = "nothing"
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
            Text("Work In Progress")
                .font(.title)
            Spacer()
            Text("This page is going to contain \(newContent)")
            Spacer()
        }
        .navigationTitle("Work In Progress")
    }
}

struct WIPView_Previews: PreviewProvider {
    static var previews: some View {
        WIPView()
    }
}

