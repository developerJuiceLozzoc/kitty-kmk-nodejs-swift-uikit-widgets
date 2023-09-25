//
//  RequiredToyView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 9/24/23.
//

import SwiftUI

struct RequiredToyView: View, Identifiable {
    let toy: ToyItemUsed
    let id: String
    
    var content: some View {
        ZStack {
        
            VStack {
                toy.type.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color(SceneCat.randomActiveColor))
                    .opacity(0.7)

                    .frame(width: 300)
                    .blur(radius: 40)
                
                Text(toy.type.toString())
                    .foregroundColor(.white)
                    .font(.title)
                    .lineLimit(nil)
                if toy.dateAdded != 0 {
                    Text("Adopted on this date")
                        .foregroundColor(.white)
                        .font(.custom("Arial", size: 24))
                        .lineLimit(nil)
                }
            }
            .padding(.all, toy.dateAdded == 0.0 ? 0.0 : 16)
            .border(toy.dateAdded == 0.0 ? .clear : .purple, width: 5)
           
            toy.type.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height:  150)
                .id(id)
                
        }
    }
    var body: some View {
        content
            .padding(.all, 32)
            .background(
                KMKSwiftUIStyles.i.renderDashboardTileBG()
            )
            .shadow(radius: 5)
    }
}

struct RequiredToyView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RequiredToyView(toy: .init(dateAdded: 10, type: .catMouse, hits: 0), id: "69")
            RequiredToyView(toy: .init(dateAdded: 0.0, type: .chewytoy, hits: 0), id: "69")
            RequiredToyView(toy: .init(dateAdded: 0.0, type: .scratchpost, hits: 0), id: "69")
        }
    }
}
