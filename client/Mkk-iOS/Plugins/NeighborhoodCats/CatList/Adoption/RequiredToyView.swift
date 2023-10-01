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
                Spacer()
            }
            toy.type.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .id(id)
            VStack {
               
            }
            .padding(.all, toy.dateAdded == 0.0 ? 0.0 : 16)
           
           
                
        }
    }
    
    var textViews: some View {
        VStack(spacing: 12) {
            Text(toy.type.toString())
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.white)
                .font(.body)
                .lineLimit(nil)
            if toy.dateAdded != 0 {
                Text("Adopted on this date")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white)
                    .font(.custom("Arial", size: 12))
                    .lineLimit(nil)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(style: .init(lineWidth: 1))
                .foregroundColor(Color.gray)
                .shadow(radius: 5)

            
            
        }
        .shadow(radius: 5)
    }
    var body: some View {
        toy.type.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color(SceneCat.randomActiveColor))
            .opacity(0.7)
            .blur(radius: 20)
            .overlay {
                VStack {
                    content
                        .frame( width: 100, height: 100)
                        .padding(.all, 32)
                        .background(
                            KMKSwiftUIStyles.i.renderDashboardTileBG()
                        )
                        .shadow(radius: 5)
                   textViews
                }
                
            }
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
