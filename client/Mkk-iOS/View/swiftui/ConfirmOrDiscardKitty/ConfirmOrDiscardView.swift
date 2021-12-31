//
//  ConfirmOrDiscardView.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import SwiftUI

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



struct ConfirmOrDiscardView: View {
    @State var imageSelected: Int = -1
    @State var sirname: String = ""
    @State var selectedImage: Int = -1
    var onAdoptionClick: ((String,KittyBreed,Data) -> Void)?
    
    var emojieSectionDetails = [RowCellDataSource]()
    var section1Details = [RowCellDataSource]()
    let description: String
    let stats: KittyBreed

    init(stats: KittyBreed, onAdoptionClick: @escaping ((String,KittyBreed,Data) -> Void)) {
        self.description = stats.description
        self.stats = stats
        
        self.section1Details.append((name: "Name", value: stats.intelligence, stringValue: stats.name, varient: 1))
        self.section1Details.append((name: "Country Of Origin", value: stats.intelligence, stringValue:stats.origin, varient: 1))
        self.section1Details.append((name: "Lifespan", value: stats.intelligence, stringValue:"\(stats.life_span) years", varient: 1))
        self.section1Details.append((name: "Shedding Lvl", value: stats.shedding_level, stringValue:"🐾", varient: 0))
        
        self.emojieSectionDetails.append((name: "Intelligence", value: stats.intelligence, stringValue:"🧠", varient: 0))
        self.emojieSectionDetails.append((name: "Stranger Friendly", value: stats.stranger_friendly, stringValue:"🧟‍♂️", varient: 0))
        self.emojieSectionDetails.append((name: "Energy Lvl", value: stats.energy_level, stringValue:"⚡️", varient: 0))
        self.emojieSectionDetails.append((name: "Dog Friendly", value: stats.dog_friendly, stringValue:"🐶", varient: 0))
        
        
    }
    

    var body: some View {
        GeometryReader { metrics in
        List {
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
            
            Section {
                HStack{
                    Text("Name").foregroundColor(Color("form-label-color"))
                    Spacer()
                    TextField(
                        MOCK_NAMES.randomElement() ?? "Steven Burg McFartyPants",
                            text: $sirname
                        )
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.fixed(50)), count: 3)) {
                        ForEach(0..<ds.datas.count) { i in
                            let data: Data? = ds.loadImage(for: i)
                            let loadingData: Data = UIImage(named: "placeholder-image")?.pngData() ?? Data()
                            let uiimage = UIImage(data: data ?? loadingData) ?? UIImage()
                            ZStack {
                                Image(uiImage: uiimage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                if(selectedImage == i){
                                    VStack {
                                        Spacer()
                                        Text("🤩")
                                            .font(.system(.title))
                                    }
                                }
                                
                            }.onTapGesture {
                                    if selectedImage == i {
                                        selectedImage = -1
                                    } else {
                                        selectedImage = i
                                    }
                                }
                            
                        }
                        
                    }
                }.frame(height: 420)
                
                
                    
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Choose Form for Soul to materialize")
            }
            Section {
                Button {
                    guard sirname.count > 0, selectedImage != -1, let selectedImageData = ds.datas[selectedImage]   else {return}
                    onAdoptionClick?(sirname, stats, selectedImageData)
                } label: {
                    Text("Adopt this Kitty")
                        .padding()
                        .foregroundColor(Color("submit-fg-green"))
                }
            }header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Decision")
            }

        }
    }
    }
}

//struct ConfirmOrDiscardView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ConfirmOrDiscardView(stats: dummyBreed, onAdoptionClick: { name,stats, data in }).preferredColorScheme(.dark).environmentObject(dummyEnv)
//            ConfirmOrDiscardView(stats: dummyBreed, onAdoptionClick: { name,stats, data in }).preferredColorScheme(.light)
//                .environmentObject(dummyEnv)
//        }
//    }
//}
