//
//  KittyDetailsView.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import SwiftUI
import UIKit
import CoreData


let dummyBreed =  KittyBreed(
    id: "69",
    name: "Shorthair",
    temperament: "needy, active, intelligent, playful, likes-sniffing",
    description: "The FitnessGram™ Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues. The 20 meter pacer test will begin in 30 seconds. Line up at the start. The running speed starts slowly, but gets faster each minute after you hear this signal.",
    life_span: "6 - 9",
    dog_friendly: 5,
    energy_level: 1,
    shedding_level: 1,
    intelligence: 5,
    stranger_friendly: 5,
    origin: "United States",
    image: imgtype(url: "https://placekitten.com/300/300"))
let pix = ["https://placekitten.com/300/300","https://placekitten.com/350/350","https://placekitten.com/250/250"]


typealias RowCellDataSource = (name: String, value: Int, stringValue: String, varient: Int)

struct KittyDetailsView: View {
    var pfp: UIImage
    var description: String
    var emojieSectionDetails = [RowCellDataSource]()
    var section1Details = [RowCellDataSource]()
    let name: String
    let modelDelegate: KMKCoreData?
    let kittyUID: NSManagedObjectID
    let temperment: String

    init(stats: KittyBreed, pfp: UIImage, name: String, birthday: Double, delegate: KMKCoreData?,id: NSManagedObjectID) {
        self.modelDelegate  = delegate
        self.pfp = pfp
        self.description = stats.description
        self.name = name
        self.kittyUID = id
        self.temperment = stats.temperament
        self.section1Details.append((name: "Name", value: stats.intelligence, stringValue: stats.name, varient: 1))
        self.section1Details.append((name: "Country Of Origin", value: stats.intelligence, stringValue:stats.origin, varient: 1))
        self.section1Details.append((name: "Adopted On", value: stats.intelligence, stringValue: doubleDateToString(from: birthday), varient: 1))
        self.section1Details.append((name: "Lifespan", value: stats.intelligence, stringValue:"\(stats.life_span) years", varient: 1))
        self.section1Details.append((name: "Shedding Lvl", value: stats.shedding_level, stringValue:"🐾", varient: 0))
        
        self.emojieSectionDetails.append((name: "Intelligence", value: stats.intelligence, stringValue:"🧠", varient: 0))
        self.emojieSectionDetails.append((name: "Stranger Friendly", value: stats.stranger_friendly, stringValue:"🧟‍♂️", varient: 0))
        self.emojieSectionDetails.append((name: "Energy Lvl", value: stats.energy_level, stringValue:"⚡️", varient: 0))
        self.emojieSectionDetails.append((name: "Dog Friendly", value: stats.dog_friendly, stringValue:"🐶", varient: 0))
        
        
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
                    TemperamentView(traits: parseTemperament(with: temperment))
                }
                Section {
                    ForEach(0..<section1Details.count, id: \.self) {
                        EmojiSectionView(screenWidth: metrics.size.width, ds: section1Details[$0])
                    }
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Kitty Breed")
                }
                Section {
                    Text(description)
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Description")
                }
                Section {
                    ForEach(0..<emojieSectionDetails.count, id: \.self) {
                        EmojiSectionView(screenWidth: metrics.size.width, ds: emojieSectionDetails[$0])
                    }
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Personality Traits")

                }
                
                
               
            }
        }.navigationTitle(Text(name))
        .onAppear {
            let _ = modelDelegate?.updateKittyLastAccesed(using: self.kittyUID)
        }

        }
    }
}

struct KittyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        KittyDetailsView(stats: dummyBreed, pfp: UIImage(named: "roxy-butt") ?? UIImage(), name: "Mock Name", birthday: Date().timeIntervalSince1970, delegate: nil, id: NSManagedObjectID()).preferredColorScheme(.light)
//        KittyDetailsView(stats: dummyBreed, pfp: UIImage(named: "roxy-butt") ?? UIImage(), name: "Mock Name", birthday: Date().timeIntervalSince1970).preferredColorScheme(.dark)
    }
}
