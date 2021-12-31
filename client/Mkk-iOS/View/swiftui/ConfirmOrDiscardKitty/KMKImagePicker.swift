//
//  KMKImagePicker.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/31/21.
//

import SwiftUI

struct KMKImagePicker: View {
    @EnvironmentObject var ds: KittyPFPViewModel
    @Binding var selectedImage: Int
    @Binding var selectedImageData: Data?
    let width: CGFloat
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.fixed(150),spacing: 25), count: 2)) {
                ForEach(0..<ds.datas.count) { i in
                    let data: Data? = ds.loadImage(for: i)
                    let loadingData: Data = UIImage(named: "placeholder-image")?.pngData() ?? Data()
                    let uiimage = UIImage(data: data ?? loadingData) ?? UIImage()
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
                                selectedImageData = ds.datas[selectedImage]
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

    static let vm: KittyPFPViewModel = KittyPFPViewModel(count: 50, urls: Array.init(repeating: "https://placekitten.com/200/200", count: 50))
    
    static var previews: some View {
        List {
            Section {
                KMKImagePicker(selectedImage: $selectedImage,selectedImageData: $selectedImageData, width: UIScreen.main.bounds.width)
                    .environmentObject(vm)
            }
        }
        
        
    }
}
