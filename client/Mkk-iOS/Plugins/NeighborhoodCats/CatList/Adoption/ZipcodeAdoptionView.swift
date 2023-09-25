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
    let kitty: ZipcodeCat
    
    @State var imageUrls: [String] = []
    @ObservedObject var viewModel: ZipcodeAdoptions.ViewModel
    
    
    
    init( kitty: ZipcodeCat, onAdoptionClick: @escaping ((String,KittyBreed,Data) -> Void)) {
        self.urls = ["https://placekitten.com/400/400"]
        self.onAdoptionClick = onAdoptionClick
        self.kitty = kitty
        self.viewModel = ZipcodeAdoptions.ViewModel(with: kitty)
    }
    
    private var sceneView: some View {
        ZStack {
            SceneKitView(
                scene: viewModel.nonObservables.scene,
                onNodeSelected: { _ in },
                delegate: viewModel.nonObservables.sceneDelegate
            )
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25)
            if viewModel.observables.isSceneLoading == .success(true) {
                KMKLoadingIndicator(bodyText: "Neighboorhood scene resources Loading")
            }
        }
    }
    
    let placeHolderName =
    MOCK_NAMES.randomElement() ?? "Steven Burg McFartyPants"
    var body: some View {
        GeometryReader { metrics in
        List {
            Section {
                ResizingAdoptionRequirementsView(toysExisting: [.init(dateAdded: Date.now.timeIntervalSince1970, type: .catMouse, hits: 3)], toysNeeded: [.catMouse, .foodPuzzle,.unknown,.yarnball])
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Required Toys")
            }
            
            
            sceneView
            
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
                    TextField(placeHolderName,
                            text: $sirname
                        )
                }
                /*KMKImagePicker( selectedImage: $selectedImage, selectedImageData: $selectedImageData, urls: self.urls, width: metrics.size.width)*/
                
                
                    
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
        return kitty.breed
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
            ZipcodeAdoptionView(kitty: ZipcodeCat.previews[0]) { _, _, _ in
                
            }
        }
    }
}
