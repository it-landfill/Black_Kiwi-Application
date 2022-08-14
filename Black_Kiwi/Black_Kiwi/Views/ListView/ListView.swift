//
//  ListView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct ListView: View {
    
    @Binding var POIList: [POIModel.Item]
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    
    var body: some View {
        NavigationView {
            List($POIList){ POI in
                NavigationLink(destination: POIDetailView(POI: POI)){
                        ListElementView(POI: POI)
                }
            }
            .navigationTitle("POI List")
        }
        .navigationViewStyle(.automatic) //Questo genera una mole di contstraint warning su iphone, per risolverli bisognerebbe sostituire .automatic con .stack. Questo però comporterebbe una view a stack anche su ipad / mac
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
            ListView(POIList: .constant(POIModel.Item.sampleData))
    }
}
