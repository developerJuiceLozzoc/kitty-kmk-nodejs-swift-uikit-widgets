//
//  KMKLoadingIndicator.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/16/23.
//

import SwiftUI

struct KMKLoadingIndicator: View {
    var bodyText: String
    
    var body: some View {
        VStack{
            HStack {
                Text("Please Wait")
                    .font(.headline)
                    .frame(height: 50)
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
                    .tint(Color("ultra-violet-1"))
            }

            HStack {
                Text(bodyText)
                        .multilineTextAlignment(.leading)
                Spacer()
            }
            
                

        }
        .padding([.leading, .trailing, .bottom])
        .background(
            KMKSwiftUIStyles.i.renderDashboardTileBG()
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .frame(width: UIScreen.main.bounds.width * 0.75)
    }
}

struct KMKLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        KMKLoadingIndicator(bodyText: "Neighboorhood scene resources Loading ")
            
    }
}
