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




struct InfoXRowYStars: View {
    var datasource: StarStatHead2Head
    var body: some View {
        VStack{
            ForEach(0..<datasource.names.count){ i in
                HStack {
                    KMKProgressRectangle(percent: datasource.ratings[0][i] / 5.0, alignment: .leading, edge: .leading)
                    Spacer()
                    Text(datasource.names[i])
                    Spacer()
                    KMKProgressRectangle(percent: datasource.ratings[1][i] / 5.0, alignment: .trailing,edge: .trailing)
                    
                }
            }
        }
        
    }
}

let dummydata = StarStatHead2Head(names: ["cat","kitty","meowster","ricky martin"], ratings: [[1,1,6,1,1],[3,1,5,3,2]])

struct JumbotronLayout: View {
    let ThickDarkInnerBorderPosition: CGFloat = 8 // 3 - 25
    let DimOuterBorderPosition: CGFloat = 8 // 0 - 15
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    Image("kat1")
                        .resizable()
                        .aspectRatio(0.78, contentMode: .fit)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Image("kat2")
                        .resizable()
                        .aspectRatio(0.78, contentMode: .fit)
                    
                }
            }
            .cornerRadius(10)
            HStack{
                Text("Name 1")
                Spacer()
                Text("name 2")
            }
            .cornerRadius(10)
            Divider()
            
            InfoXRowYStars(datasource:
                                dummydata)
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
        JumbotronLayout()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
