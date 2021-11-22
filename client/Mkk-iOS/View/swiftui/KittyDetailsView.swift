//
//  KittyDetailsView.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import SwiftUI
import UIKit

struct KittyDetailsView: View {
    var styles = SwiftUIStyles()
    var stats: KittyBreed
    var pfp: UIImage
    var name: String
    var birthday: Double
    
    var body: some View {
        GeometryReader { metrics in
        VStack{
            Image(uiImage: pfp)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
            List {
                Section {
                    if #available(iOS 15.0, *) {
                    styles.renderImportantTextWithLabel(with: name, label: "Name", width: metrics.size.width)
                            .listRowSeparatorTint(Color("ultra-violet-1"))

                    styles.renderImportantTextWithLabel(with: doubleDateToString(from: birthday), label: "Adopted On", width: metrics.size.width)
                            .listRowSeparatorTint(Color("ultra-violet-1"))
                        TemperamentView(traits: parseTemperament(with: stats.temperament))
                            .listRowSeparatorTint(Color("ultra-violet-1"))

                    } else {
                        styles.renderImportantTextWithLabel(with: name, label: "Name", width: metrics.size.width)
                        styles.renderImportantTextWithLabel(with: doubleDateToString(from: birthday), label: "Adopted On", width: metrics.size.width)
                        TemperamentView(traits: parseTemperament(with: stats.temperament))

                    }
                }
                Section {
                    if #available(iOS 15.0, *) {
                        styles.renderTextWithLabel(with: stats.name, label: "Breed", width: metrics.size.width)
                            .listRowSeparatorTint(Color("ultra-violet-1"))
                        styles.renderTextWithLabel(with: stats.description, label: "Desc", width: metrics.size.width)
                            .listRowSeparatorTint(Color("ultra-violet-1"))
                        styles.renderImportantTextWithLabel(with: stats.origin, label: "Origin Country", width: metrics.size.width)
                                .listRowSeparatorTint(Color("ultra-violet-1"))
                    } else {
                        styles.renderTextWithLabel(with: doubleDateToString(from: birthday), label: "Adopted On", width: metrics.size.width)
                        styles.renderTextWithLabel(with: stats.description, label: "Desc", width: metrics.size.width)
                        styles.renderImportantTextWithLabel(with: stats.origin, label: "Origin Country", width: metrics.size.width)
                    }
                } header: {
                    styles.renderSectionHeader(with: "Breed")
                }
                EmojiSectionView(stats: stats, screenWidth: metrics.size.width)
                
                
               
            }
        }
        }
    }
}

struct KittyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        KittyDetailsView(stats: dummyBreed, pfp: UIImage(named: "roxy-butt") ?? UIImage(), name: "Mock Name", birthday: Date().timeIntervalSince1970).preferredColorScheme(.light)
//        KittyDetailsView(stats: dummyBreed, pfp: UIImage(named: "roxy-butt") ?? UIImage(), name: "Mock Name", birthday: Date().timeIntervalSince1970).preferredColorScheme(.dark)
    }
}
