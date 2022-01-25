//
//  KMKImagePicker.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/31/21.
//

import SwiftUI

struct KMKImagePicker: View {
    @EnvironmentObject var vm: KittyPFPViewModel
    @Binding var selectedImage: Int
    @Binding var selectedImageData: Data?
    let urls: [String]
    let width: CGFloat
    
    func loadImage(for url: String) -> UIImage {
        guard let image: UIImage = vm.cache.object(forKey: url as AnyObject) else {
            vm.loadImage(for: url)
            return UIImage(named: "placeholder-image") ?? UIImage()
        }
        return image
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.fixed(150),spacing: 25), count: 2)) {
                ForEach(0..<urls.count) { i in
                    let uiimage = loadImage(for: urls[i])

                    ZStack {
                        Image(uiImage: uiimage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (width - 130) / 2)
                            .padding(2)
                            .overlay(
                                KMKSwiftUIStyles.i.renderDashboardTileBorder())
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
                                selectedImageData = nil
                            } else {
                                selectedImage = i
                                selectedImageData = uiimage.pngData()
                            }
                        }
                    
                }
                
            }
        }.frame(height: 420)
    }
}

struct KMKImagePicker_Previews: PreviewProvider {
    @State static var selectedImage: Int = -1
    @State static var selectedImageData: Data? = Data()

    static let vm: KittyPFPViewModel = KittyPFPViewModel()
    
    static var previews: some View {
        List {
            Section {
                KMKImagePicker(selectedImage: $selectedImage,selectedImageData: $selectedImageData, urls: ["https://placekitten.com/400/400"], width: UIScreen.main.bounds.width)
                    .environmentObject(vm)
            }
        }
        
        
    }
}
