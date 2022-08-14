//
//  SearchBarComponentView.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 14/08/22.
//

import SwiftUI

struct SearchBarComponentView: View {
    
    @State private var text = ""
    @State private var isSearching = false //TODO: Inutilizzata
    
    @Binding var restHeights: [CGFloat]
    
    
    var body: some View {
        
        //FIXME: Se il drawer è aperto al massimo la tastiera lo alza fuori dallo schermo
        
        HStack{
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    isSearching = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
                .onSubmit({
                    print("Searching for \(text)")
                })
            
            if text != "" {
                Button(action: {
                    self.text = ""
                    self.isSearching = false
                    withAnimation(.default){
                        
                    }
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        
    }
}

struct SearchBarComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarComponentView(restHeights: .constant([]))
            .previewLayout(.sizeThatFits)
    }
}

