//
//  HintWrapper.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct HintWrapper<Content: View>: View {
    var content: () -> Content
    var type: ActionCellGestureType
    init(@ViewBuilder content: @escaping () -> Content, of type: ActionCellGestureType) {
        self.content = content
        self.type = type
    }
    
    var body: some View {
        ZStack {
            content() 
            VStack {
                HStack {
                    Spacer()
                    Text("Help!")
                }
                Spacer()
                
            }
            .padding()
            
        }

    }
}

struct HintWrapper_Previews: PreviewProvider {
    static var previews: some View {
        HintWrapper(content: {
            Text("Racecar tacocat")
        }, of: .tap)
    }
}
