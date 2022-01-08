//
//  WhileYouWereAwayAlert.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/1/22.
//

import SwiftUI
import RealmSwift

struct WhileYouWereAwayAlert: View {
    var ds: KittyPlaygroundState
    @ObservedResults(UnownedKittyInPlayground.self, sortDescriptor:
        SortDescriptor(keyPath: "uid", ascending: true))
        var wanderingKitties
    var vm: KittyPFPViewModel!
    var rlm = RealmCrud()
    @State var isNavigationLinkActive: Bool = false

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ForEach(ds.toys, id: \.self) {
                            ToyItumListView(ds: $0 )
                        }
                    } header: {
                        KMKSwiftUIStyles.i.renderSectionHeader(with: "Toys used by these cats")
                    }
                }
                Divider()
                List(wanderingKitties) { kitty in
                    HStack{
                        KMKSwiftUIStyles.i.renderSelectedTile(isSelected: true, text: kitty.statsLink?.name ?? "Ooops")
                        NavigationLink(kitty.statsLink?.name ?? "Ooops", isActive: $isNavigationLinkActive) {
                            let vm = KittyPFPViewModel(count: kitty.imgurls.count, urls: kitty.imgurls.map { $0 })
                            ConfirmOrDiscardView(kitty: kitty, isPresented: $isNavigationLinkActive, onAdoptionClick: { name,stats, data in
                                DispatchQueue.main.async {
                                    self.rlm.addTodooeyToRealm(name: name, stats: stats, imgurl: "", imgdata: data)
                                }
                            })
                                .environmentObject(vm)
                                .onDisappear {
                                    print("ondisappear")
                                    DispatchQueue.main.async {
                                        rlm.deleteWanderingItemWithRealm(ref: kitty)
                                    }
                                }
                            
                    }

                    }
                }
                
            }
        }
    }
}


