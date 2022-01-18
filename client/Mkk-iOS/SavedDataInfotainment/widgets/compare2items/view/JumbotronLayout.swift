//
//  JumbotronLayout.swift
//  Mkk-iOS
//
//  Created by Conner M on 9/19/21.
//

import UIKit
import SwiftUI
import WidgetKit

struct StarStatHead2Head {
    var names: [String]
    var ratings: [[CGFloat]]
}


func renderPetName(name: String) -> some View {
    let count = name.split(separator: " ").count
    var size: CGFloat
    switch count {
        case 1:
            size = 20
            if name.count > 11 {
                size = 17
            }
        case 2:
            size = 16
        default:
            size = 12
    }
    return Text(name).font(.system(size: size, weight: .light, design: .default))
}


struct InfoXRowYStars: View {
    var datasource: StarStatHead2Head
    var body: some View {
        VStack{
            ForEach(0..<datasource.names.count){ i in
                HStack {
                    KMKProgressRectangle(percent: datasource.ratings[0][i] / 5.0, alignment: .leading, edge: .leading)
                    renderPetName(name: datasource.names[i])
                    KMKProgressRectangle(percent: datasource.ratings[1][i] / 5.0, alignment: .trailing,edge: .trailing)
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

let dummydata = StarStatHead2Head(names: ["cat","kitty mclovin","meowster","ricky martin charles"], ratings: [[1,1,6,1,1],[3,1,5,3,2]])

struct JumbotronLayout: View {
    let ThickDarkInnerBorderPosition: CGFloat = 8 // 3 - 25
    let DimOuterBorderPosition: CGFloat = 8 // 0 - 15
    var imageLeft: Image!
    var imageRight: Image!
    var nameLeft: String!
    var nameRight: String!
    var stats:StarStatHead2Head!
    
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    imageLeft
                        .resizable()
                        .aspectRatio(0.78, contentMode: .fit)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    imageRight
                        .resizable()
                        .aspectRatio(0.78, contentMode: .fit)
                    
                }
            }
            .cornerRadius(10)
            HStack{
                Text(nameLeft)
                Spacer()
                Text(nameRight)
            }
            .cornerRadius(10)
            Divider()
            
            InfoXRowYStars(datasource: stats)
                .padding()
            
            
        }
        .border(LinearGradient(gradient:
                                Gradient(colors: [Color("dark-purple"),.white,Color("dark-purple")]),
                               startPoint: .leading,
                               endPoint: .trailing), width: ThickDarkInnerBorderPosition)

        .border(RadialGradient(gradient: Gradient(colors: [Color("dark-purple"),.white]), center: .center, startRadius: 750, endRadius: 100), width: DimOuterBorderPosition)
        .cornerRadius(10)
    }
    
}

struct JumbotronLayout_Previews: PreviewProvider {
    static var previews: some View {
//        JumbotronLayout()
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        JumbotronLayout()
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
        JumbotronLayout(imageLeft: Image("kat1"), imageRight: Image("kat2"), nameLeft: "Charles Vanderburg", nameRight: "Ricky Martin", stats: dummydata)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
