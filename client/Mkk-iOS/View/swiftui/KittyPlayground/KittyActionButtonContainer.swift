//
//  KittyActionButtonContainer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct KittyActionButtonContainer: View {
    @State var ds: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [])
    var model = KittyPlistManager()
    var body: some View {
        HStack(spacing: 21){
            
            VStack {
                PourWaterTile(store: $ds)
                Spacer()
            }
            VStack {
                Spacer()
                FoodBowlTile(store: $ds)
                UseToyTile(store: $ds)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: PourWaterTile.tileHeight + 75)
        .onAppear {
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
        KittyActionButtonContainer(ds: KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: 0, type: .chewytoy)]))
    }
}
