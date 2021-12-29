//
//  UseToyTile.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct UseToyTile: View {
    @State var showToyMenu = false

    var body: some View {
        Button(action: {
            showToyMenu.toggle()
        }) {
            Text("Show License Agreement")
        }
        .sheet(isPresented: $showToyMenu, onDismiss: onDismissToyDrawer) {
            
        }

    }
    
    func onDismissToyDrawer() {
        // check if toys have been selected
        showToyMenu.toggle()
    }
}

struct UseToyTile_Previews: PreviewProvider {
    static var previews: some View {
        UseToyTile()
    }
}
