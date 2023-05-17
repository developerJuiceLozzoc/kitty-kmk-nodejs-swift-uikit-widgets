//
//  ZipcodeAdoptionView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/13/23.
//

import SwiftUI



struct ZipcodeAdoptionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var imageSelected: Int = -1
    @State var sirname: String = ""
    @State var selectedImage: Int = -1
    @State var selectedImageData: Data? = nil
    var onAdoptionClick: ((String,KittyBreed,Data) -> Void)
    var urls: [String]
    let _cdkitty: WanderingKitty?
    let _kittybreed: KittyBreed?
    
    @State var imageUrls: [String] = []
    

    //previews
    init(breed: String,
         onAdoptionClick: @escaping ((String,KittyBreed,Data) -> Void) = { (_, _, _) in } ) {
        self.onAdoptionClick = onAdoptionClick
        self._cdkitty = nil
        self.urls = []
        self._kittybreed = nil
    }
    
    init(urls: [String], kitty: WanderingKitty, onAdoptionClick: @escaping ((String,KittyBreed,Data) -> Void)) {
        self._cdkitty = kitty
        self.urls = urls
        self.onAdoptionClick = onAdoptionClick
        self._kittybreed = nil
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
                Text(longText)
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
                KMKImagePicker( selectedImage: $selectedImage, selectedImageData: $selectedImageData, urls: self.urls, width: metrics.size.width)
                
                
                    
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Choose Form for Soul to materialize")
            }
            Section {
                Button {
        
                    guard sirname.count > 0, selectedImage != -1, let selectedImageData = selectedImageData,
                          let breed = self.breed
                    else {return}
                    
                    onAdoptionClick(sirname, breed, selectedImageData)
                    presentationMode.wrappedValue.dismiss()
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
    
    var breed: KittyBreed? {
        if let cd = _cdkitty?.stats {
            return KittyBreed(fromCoreData: cd)
        } else {
            return _kittybreed
        }
    }
    
    var  longText: String {
        self.breed?.description ?? "desc"
    }
    
    var emojieSectionDetails: [RowCellDataSource] {
        guard let stats = self.breed else {
            return []
        }
        
        var details = [RowCellDataSource]()
        
        details.append((name: "Intelligence", value: stats.intelligence, stringValue:"🧠", varient: 0))
        details.append((name: "Stranger Friendly", value: stats.stranger_friendly, stringValue:"🧟‍♂️", varient: 0))
        details.append((name: "Energy Lvl", value: stats.energy_level, stringValue:"⚡️", varient: 0))
        details.append((name: "Dog Friendly", value: stats.dog_friendly, stringValue:"🐶", varient: 0))
        
        return details
    }
    
    var  section1Details: [RowCellDataSource] {
        guard let stats = self.breed else {
            return []
        }
        var details = [RowCellDataSource]()
        details.append((name: "Name", value: stats.intelligence, stringValue: stats.name, varient: 1))
        details.append((name: "Country Of Origin", value: stats.intelligence, stringValue:stats.origin, varient: 1))
        details.append((name: "Lifespan", value: stats.intelligence, stringValue:"\(stats.life_span) years", varient: 1))
        details.append((name: "Shedding Lvl", value: stats.shedding_level, stringValue:"🐾", varient: 0))
        
       return details
    }
}

struct ZipcodeAdoptionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ConfirmOrDiscardView(urls: ["https://placekitty.com/690/690"], kitty: KittyBreed.previews)
//                .environmentObject(KittyPFPViewModel())
//                .preferredColorScheme(.dark)
        }
    }
}
