//
//  LazyVRadioBox.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/21/22.
//

import SwiftUI
import UIKit

struct GroupFilterRadioBox: View {
    var columns: [GridItem] =
    Array(repeating: GridItem.init(.fixed(UIScreen.main.bounds.width / 2.5), spacing: 15), count: 2)
    let strings: [String]
    @Binding var selectedGrouping: Int
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach((0..<strings.count), id: \.self) { index in
                Button {
                    
                } label: {
                    Text(strings[index])
                        .bold()
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .foregroundColor(Color("radio-button-text"))
                        .padding()
                        .background(selectedGrouping == index ? Color("emoji-foreground") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: selectedGrouping == index ? 3 : 1)
                                .foregroundColor(Color("ultra-violet-1"))
                        )
                    
                }.onTapGesture {
                    selectedGrouping = index
                }
                
            }
        }
    }
    
    
}

