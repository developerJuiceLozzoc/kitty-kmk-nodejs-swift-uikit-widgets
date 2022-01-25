//
//  WhileYouWereAwayAlert.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/1/22.
//

import SwiftUI
import RealmSwift

struct WhileYouWereAwayAlert: View {
    @ObservedObject var presenter = WanderingKittyViewModel()
    let ds: KittyPlaygroundState
    @ObservedObject var vm: KittyPFPViewModel = KittyPFPViewModel()
    let cd = KMKCoreData()
    
    @State private var refreshID = UUID()
    let didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    init() {
        ds = KittyPlistManager().LoadItemFavorites() ?? KittyPlaygroundState(foodbowl: 0, waterbowl: 0, toys: [])
    }
    
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
                List {
                    ForEach(presenter.kitties) { kitty in
                        NavigationLink {
                            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: kitty.imgurls!)
                            let toys: [ToyType] = try! JSONDecoder().decode([Int].self, from: kitty.toysInteracted!).map { ToyType(rawValue: $0) ?? .unknown }
                            
                            ConfirmOrDiscardView(urls: arrayBack, kitty: kitty, onAdoptionClick: { name, stats, pfp in
                            _ = cd.createKitty(using: stats, name: name, toys: toys, pfp: pfp)

                            }).environmentObject(vm)
                                .onDisappear {
                                    cd.deleteWanderingKitty(using: kitty.objectID)
                                    presenter.update()

                                }
                        } label: {
                            KMKSwiftUIStyles.i.renderSelectedTile(isSelected: true, text: kitty.stats?.name ?? "Ooops")
                        }
                    }

                }
                .onAppear {
                    if presenter.kitties.isEmpty {
                        presenter.update()

                    }
                }
                .onDisappear {
                    vm.cache = [:]
                }
                
            }
        }
    }
}


