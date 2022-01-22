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
    var vm: KittyPFPViewModel!
    var cd = KMKCoreData()
    @State var isNavigationLinkActive: Bool = false
    @FetchRequest(
        entity: WanderingKitty.entity(),
        sortDescriptors: [],
        predicate: nil,
        animation: nil
    )var kitties: FetchedResults<WanderingKitty>
    
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
                    
ForEach(kitties, id: \.self) { (kitty: WanderingKitty) in
    HStack{
        KMKSwiftUIStyles.i.renderSelectedTile(isSelected: true, text: kitty.stats?.name ?? "Ooops")
        NavigationLink(isActive: $isNavigationLinkActive) {
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: kitty.imgurls!)
            let vm = KittyPFPViewModel(count: arrayBack.count, urls: arrayBack)
            ConfirmOrDiscardView(kitty: kitty, isPresented: $isNavigationLinkActive, onAdoptionClick: { name, stats, pfp in
                
            }).environmentObject(vm)
        } label: {
            Text(kitty.stats?.name ?? "")
        }
            
    }
}
                }
                
            }
        }
    }
}


