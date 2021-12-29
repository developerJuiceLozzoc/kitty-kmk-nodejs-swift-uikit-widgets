//
//  KittyActionButtonContainer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct KittyActionButtonContainer: View {
    @State var ds: KittyPlaygroundState?
    var model = KittyPlistManager()
    var body: some View {
        HStack(spacing: 21){
            PourWaterTile(liters:  50)
            VStack {
                FoodBowlTile(pounds: 50)
                UseToyTile()
            }
        }.onAppear {
            guard ds == nil else { return }
            if let store = model.LoadItemFavorites() {
                ds = store
            }
            else {
                print("there is no store")
                ds = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [])
            }
        }
    }
}

struct KittyActionButtonContainer_Previews: PreviewProvider {
    static var previews: some View {
        KittyActionButtonContainer()
    }
}
