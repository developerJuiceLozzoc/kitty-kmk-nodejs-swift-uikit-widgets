//
//  KittyDetailsView.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import SwiftUI
import UIKit

typealias RowCellDataSource = (name: String, value: Int, stringValue: String, varient: Int)

struct KittyDetailsView: View {
    var pfp: UIImage
    var description: String
    var emojieSectionDetails = [RowCellDataSource]()
    var section1Details = [RowCellDataSource]()

    init(stats: KittyBreed, pfp: UIImage, name: String, birthday: Double) {
        self.pfp = pfp
        self.description = stats.description
        self.section1Details.append((name: "Name", value: stats.intelligence, stringValue: stats.name, varient: 1))
        self.section1Details.append((name: "Country Of Origin", value: stats.intelligence, stringValue:stats.origin, varient: 1))
        self.section1Details.append((name: "Adopted On", value: stats.intelligence, stringValue: doubleDateToString(from: birthday), varient: 1))
        self.section1Details.append((name: "Intelligence", value: stats.intelligence, stringValue:"🧠", varient: 0))
        self.section1Details.append((name: "Lifespan", value: stats.intelligence, stringValue:"\(stats.life_span) years", varient: 1))
        
        self.emojieSectionDetails.append((name: "Intelligence", value: stats.intelligence, stringValue:"🧠", varient: 0))
        self.emojieSectionDetails.append((name: "Stranger Friendly", value: stats.stranger_friendly, stringValue:"🧟‍♂️", varient: 0))
        self.emojieSectionDetails.append((name: "Energy Lvl", value: stats.energy_level, stringValue:"⚡️", varient: 0))
        self.emojieSectionDetails.append((name: "Dog Friendly", value: stats.dog_friendly, stringValue:"🐶", varient: 0))
        self.emojieSectionDetails.append((name: "Shedding Lvl", value: stats.shedding_level, stringValue:"🐾", varient: 0))
        
    }
    
    var body: some View {
        GeometryReader { metrics in
        VStack{
            Image(uiImage: pfp)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
            List {
                Section {
                    ForEach(0..<section1Details.count, id: \.self) {
                        EmojiSectionView(screenWidth: metrics.size.width, ds: section1Details[$0])
                    }
                }
                Section {
                    Text(self.description)
                        
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Breed")
                }

                ForEach(0..<emojieSectionDetails.count, id: \.self) {
                    EmojiSectionView(screenWidth: metrics.size.width, ds: emojieSectionDetails[$0])
                }
                
                
               
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
