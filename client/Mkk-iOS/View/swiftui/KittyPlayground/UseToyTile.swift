//
//  UseToyTile.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

// i have an array of toys

/*
 when presented with the draw it will alwayss dispaly all the toys
 and indicate when ones are being used at the current moment
 
 
 
 */

//store all the tooys in plist? or only the current ones being selected


struct UseToyTile: View {
    
    @Binding var store: KittyPlaygroundState
    @State var showToyMenu = false
    


    var body: some View {
        VStack{
            Text("Foodbowl")
        }
        .frame(width: 150, height: 150)
        .background(
            KMKSwiftUIStyles.i.renderDashboardTileBG()
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .onTapGesture(count: 1, perform: {
            showToyMenu.toggle()
        })
        .sheet(isPresented: $showToyMenu, onDismiss: onDismissToyDrawer) {
            LazyHGrid(rows: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Rows@*/[GridItem(.fixed(20))]/*@END_MENU_TOKEN@*/) {
                
                
            }
            
        }

    }
    
    func onDismissToyDrawer() {
        // check if toys have been selected
//        showToyMenu.toggle()
    }
}

struct UseToyTile_Previews: PreviewProvider {
    @State static var value = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy)])

    static var previews: some View {
        Group {
            UseToyTile(store: $value)
                        .preferredColorScheme(.dark)
        }

    }
}
