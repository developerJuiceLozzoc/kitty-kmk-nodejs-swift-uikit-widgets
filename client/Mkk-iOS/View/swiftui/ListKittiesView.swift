//
//  ListKittiesSwiftui.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/20/21.
//

import SwiftUI
import UIKit
import RealmSwift

struct ListKittiesView: View {
    @ObservedResults(KittyRealm.self, sortDescriptor:
        SortDescriptor(keyPath: "uid", ascending: true))
    var ownedKittiesUID
    
    @ObservedResults(KittyRealm.self, sortDescriptor:
        SortDescriptor(keyPath: "dateLastAccessed", ascending: true))
    var ownedKittiesAccessed
    
    @ObservedResults(KittyRealm.self, sortDescriptor:
        SortDescriptor(keyPath: "birthday", ascending: true))
    var ownedKittiesAdopted
    
    @Binding var showTutorial: Bool
    var onKittyClick: ((String) -> Void)?
    
    func detailsViewForKitty(kitty: KittyRealm) -> KittyDetailsView {
         let img = UIImage(data: kitty.photoLink?.img ?? Data()) ?? UIImage()
        let kstats = kitty.statsLink ?? KStatsRealm()
        
        let stats = KittyBreed(fromRealm: kstats)
        
        return KittyDetailsView(stats: stats, pfp: img, name: kitty.name, birthday: kitty.birthday)
    }
    
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(0..<ownedKittiesAccessed.count, id: \.self) { i in
                        if i < 7 {
                            NavigationLink {
                                detailsViewForKitty(kitty: ownedKittiesAccessed[i])
                            } label: {
                                Text(ownedKittiesAccessed[i].name)
                            }
                        }
                    }

                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Accessed")
                }
                
                Section {
                    ForEach(0..<ownedKittiesAdopted.count, id: \.self) { i in
                        if i < 7 {
                            NavigationLink {
                                detailsViewForKitty(kitty: ownedKittiesAdopted[i])
                            } label: {
                                Text(ownedKittiesAdopted[i].name)
                            }
                        }
                    }
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Adopted")
                }
                Section {
                    ForEach(0..<ownedKittiesUID.count, id: \.self) { i in
                                NavigationLink {
                                    detailsViewForKitty(kitty: ownedKittiesUID[i])
                                } label: {
                                    Text(ownedKittiesUID[i].name)
                                }
                    }
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "All")
                }
                
            }
        }
        .onAppear {
            if !ZeusToggles.shared.hasReadListTutorialCheck() {
                showTutorial.toggle()
            }
        }
        .navigationTitle(Text("List Of Cats"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showTutorial.toggle()
                }, label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(Color("ultra-violet-1"))

                })
                
            }
            
        }
    }
}

struct ListKittiesSwiftui_Previews: PreviewProvider {
    @State static var el: Bool = false
    static var previews: some View {
        ListKittiesView(showTutorial: $el,onKittyClick: { id in
            print(id)
        })
    }
}
