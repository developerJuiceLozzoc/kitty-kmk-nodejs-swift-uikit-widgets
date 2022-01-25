//
//  ListKittiesPresenter.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/21/22.
//

import SwiftUI

enum KittyListType: Int, CaseIterable {
    case date = 0
    case atoz
    case breeds
    
    func toString() -> String {
        return ["Date","Alphabetical Kitty Names","By Breed"][self.rawValue]
    }
    
}
enum KittySortOrderType: Int, CaseIterable {
    case ascend = 0
    case descend
    case rand
    func toString() -> String {
        return ["Ascending", "Descending", "Random"][self.rawValue]
    }
}


class ListKittiesPresenter: ObservableObject {
    let model = KMKCoreData()
    @Published var isKittyListEmpty: Bool
    
    init() {
        isKittyListEmpty = model.ownedKittiesIsEmpty()
    }
    
    func updateIsEmpty() {
        isKittyListEmpty = model.ownedKittiesIsEmpty()
    }

    
    func presentNoKittiesScreen() -> some View {
        return VStack {
        
        }
    }
    func presentGroupedDateList(sortOrder: KittySortOrderType) -> some View {
        let accessed: [Kitty] = model.fetchKitties(sortBy: "dateLastAccessed", sortOrder: sortOrder)
        let adopted: [Kitty] = model.fetchKitties(sortBy: "birthday", sortOrder: sortOrder)
        
        return VStack {
            List{
                Section {
                    ForEach(0..<accessed.count, id: \.self) { i in

                            NavigationLink {
                               KittyDetailsView(
                                stats: KittyBreed(fromCoreData: accessed[i].stats),
                                pfp: KMKSwiftUIStyles.i.KMKDataTransformUIImage(using: accessed[i].pfp),
                                name: accessed[i].name!,
                                birthday: accessed[i].birthday,
                                delegate: self.model, id: accessed[i].objectID)
                            } label: {
                                Text(accessed[i].name!)
                            }
                    }

                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Accessed")
                }
                Section {
                    ForEach(0..<adopted.count, id: \.self) { i in
                            NavigationLink {
                                KittyDetailsView(
                                 stats: KittyBreed(fromCoreData: adopted[i].stats),
                                 pfp: KMKSwiftUIStyles.i.KMKDataTransformUIImage(using: adopted[i].pfp),
                                 name: adopted[i].name!,
                                 birthday: adopted[i].birthday,
                                 delegate: self.model, id: adopted[i].objectID)
                            } label: {
                                Text(adopted[i].name!)
                            }
                    }

                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Adopted")
                }
            }
        }
    }
    
    func presentAlphabeticalList(sortOrder: KittySortOrderType) -> some View {
        let kitties: [Kitty] = model.fetchKitties(sortBy: "name", sortOrder: sortOrder)
        return List {
            ForEach(0..<kitties.count, id: \.self) { i in
                    NavigationLink {
                       KittyDetailsView(
                        stats: KittyBreed(fromCoreData: kitties[i].stats),
                        pfp: KMKSwiftUIStyles.i.KMKDataTransformUIImage(using: kitties[i].pfp),
                        name: kitties[i].name!,
                        birthday: kitties[i].birthday,
                        delegate: self.model, id: kitties[i].objectID)
                    } label: {
                        Text(kitties[i].name!)
                    }
            }
        }
    }
    
    
    
}
