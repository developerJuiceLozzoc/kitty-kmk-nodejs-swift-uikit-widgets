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
    
    @State var showTutorial = false
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
                    ScrollView {
                        List {
                            ForEach(0..<(ownedKittiesAccessed.count > 10 ? 10 : ownedKittiesAccessed.count), id: \.self) { i in
                                NavigationLink {
                                    detailsViewForKitty(kitty: ownedKittiesAccessed[i])
                                } label: {
                                    Text(ownedKittiesAccessed[i].name)
                                }
                            }
                        }
                    }.frame(height: UIScreen.main.bounds.height/4)
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Accessed")
                }
                
                Section {
                    ScrollView {
                        List {
                            ForEach(0..<(ownedKittiesAdopted.count > 10 ? 10 : ownedKittiesAdopted.count), id: \.self) { i in
                                NavigationLink {
                                    detailsViewForKitty(kitty: ownedKittiesAdopted[i])
                                } label: {
                                    Text(ownedKittiesAdopted[i].name)
                                }
                            }
                        }
                    }.frame(height: UIScreen.main.bounds.height/4)
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
                    }.frame(height: UIScreen.main.bounds.height/4)
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
    }
}

struct ListKittiesSwiftui_Previews: PreviewProvider {
    static var previews: some View {
        ListKittiesView(onKittyClick: { id in
            print(id)
        })
    }
}
