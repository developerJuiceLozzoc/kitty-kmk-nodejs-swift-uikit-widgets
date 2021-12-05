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

let dummyEnv = KittyPFPViewModel()


struct ConfirmOrDiscardView: View {
    var stats: KittyBreed
    var styles = SwiftUIStyles()
    @State var imageSelected: Int = -1
    @State var sirname: String = ""
    @State var selectedImage: Int = -1
    var onAdoptionClick: ((String,KittyBreed,Data) -> Void)?
    @EnvironmentObject var ds: KittyPFPViewModel
    

    var body: some View {
        GeometryReader { metrics in
        List {
            Section {
                if #available(iOS 15.0, *) {
                    styles.renderTextWithLabel(with: stats.name, label: "Breed", width: metrics.size.width)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                    TemperamentView(traits: parseTemperament(with: stats.temperament))
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                    styles.renderTextWithLabel(with: stats.description, label: "About", width: metrics.size.width)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                    styles.renderTextWithLabel(with: stats.origin, label: "Country     of Origin       ", width: metrics.size.width)
                    .listRowSeparatorTint(Color("ultra-violet-1"))


                } else {
                    styles.renderTextWithLabel(with: stats.name, label: "Breed", width: metrics.size.width)
                    styles.renderTextWithLabel(with: stats.temperament, label: "Temperament", width: metrics.size.width)
                    styles.renderTextWithLabel(with: stats.description, label: "Description", width: metrics.size.width)


                }
            } header: {
                styles.renderSectionHeader(with: "Kitty Description")
            }
            
            EmojiSectionView(stats: stats, screenWidth: metrics.size.width)
            
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
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(0..<ds.datas.count) { i in
                            
                            ZStack {
                                Image(uiImage: UIImage(data: ds.datas[i]) ?? UIImage())
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
                styles.renderSectionHeader(with: "Choose Form for Soul to materialize")
            }
            Section {
                Button {
                    guard sirname.count > 0, selectedImage != -1  else {return}
                    onAdoptionClick?(sirname, stats, ds.datas[selectedImage])
                } label: {
                    Text("Adopt this Kitty")
                        .padding()
                        .foregroundColor(Color("submit-fg-green"))
                }
            }header: {
                styles.renderSectionHeader(with: "Decision")
            }

        }
    }
    }
}

struct ConfirmOrDiscardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConfirmOrDiscardView(stats: dummyBreed).preferredColorScheme(.dark).environmentObject(dummyEnv)
            ConfirmOrDiscardView(stats: dummyBreed).preferredColorScheme(.light)
                .environmentObject(dummyEnv)
        }
    }
}
