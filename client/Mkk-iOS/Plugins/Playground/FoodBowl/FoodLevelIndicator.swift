//
//  FoodLevelIndicator.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/13/22.
//

import SwiftUI

struct FoodLevelIndicator: View {
    var lvl: Int
    var body: some View {
        ZStack {
            if lvl > 0 {
                Image("food-bowl-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            if lvl > 1 {
                Image("food-bowl-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .transformEffect(CGAffineTransform(translationX: 15, y: 15))
            }
            if lvl > 2 {
                Image("food-bowl-3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .transformEffect(CGAffineTransform(translationX: -15, y: 15))
            }
        }
    }
}

struct FoodLevelIndicator_Previews: PreviewProvider {
    static var lvlset: Int = 3
    static var previews: some View {
        FoodLevelIndicator(lvl: lvlset)
    }
}
