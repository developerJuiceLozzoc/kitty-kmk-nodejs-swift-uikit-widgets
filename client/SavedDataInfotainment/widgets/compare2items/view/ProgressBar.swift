//
//  ProgressBar.swift
//  Mkk-iOS
//
//  Created by Conner M on 9/19/21.
//

import SwiftUI
import WidgetKit

fileprivate func colorFormatter(alignment: Alignment) -> [Color] {
    if(alignment == .leading){
        return [.white,Color("dark-purple"),Color("light-purple"),]
    } else {
        return [Color("light-purple"),Color("dark-purple"),.white]
    }
}

struct KMKProgressRectangle: View {
    var percent: CGFloat // from 0 to 100
    var alignment: Alignment
    var edge: Edge.Set
    let borderWidth: CGFloat = 3
    let height: CGFloat = 25
    var body: some View {
        ZStack {
            HStack{
                if(alignment == .trailing){
                    Spacer()
                }
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(width: 110, height: height, alignment: alignment)
                    .border(Color("dark-purple"),width: borderWidth)
                if(alignment == .leading){
                    Spacer()
                }
                
            }
            
            
            HStack {
                if(alignment == .trailing){
                    Spacer()
                }
                Rectangle()
                    .foregroundColor(Color("light-purple"))
                    .frame(width: percent*100, height: height - borderWidth*2 - 2, alignment: .trailing)
                    .offset(x: alignment == .leading ? borderWidth : -1 * borderWidth, y: 0)
                if(alignment == .leading){
                    Spacer()
                }
               
            }
            
            HStack {
                if(alignment == .trailing){
                    Spacer()
                }
                LinearGradient(gradient: Gradient(colors: colorFormatter(alignment: alignment)), startPoint: .leading, endPoint: .trailing)
                    .frame(width: percent <= 0.25 ? 12.5 : 25, height: height - borderWidth*2 - 2, alignment: .trailing)
                    .offset(x: alignment == .leading ? borderWidth : -1 * borderWidth, y: 0)
                if(alignment == .leading){
                    Spacer()
                }
                

            }
        }
    }
}

struct KMKProgressRectangle_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            KMKProgressRectangle(percent: 0.1, alignment: .leading, edge: .leading)
            KMKProgressRectangle(percent: 0.25, alignment: .trailing, edge: .trailing)
            KMKProgressRectangle(percent: 0.75, alignment: .leading, edge: .leading)
            
            
            
        }.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
