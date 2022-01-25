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
            Text("Sorry you have no kitties yet.")
            Divider()
            Text("Try reading the tutorials to find out how to adopt kitties, or perhaps just set some toys out in the playground, kitties love toys.")
        }
    }
    
    func presentGroupedBreedsList(with sortOrder: KittySortOrderType) -> some View {
        let kitties = model.fetchKitties(sortBy: "breed_id", sortOrder: sortOrder)
        var breeds: [String: [Kitty]] = [:]
        kitties.forEach { k in
            breeds[k.breed_id ?? "",default: []].append(k)
        }
        var arr = breeds.keys.map { return $0 }.sorted { el, la in
            if sortOrder == .ascend {
                return el < la
            } else {
                return el > la
            }
        }
        if sortOrder == .rand {
            arr.shuffle()
        }
        
        return List {
            ForEach(0..<arr.count, id: \.self) { i in
                Section {
                    ForEach(breeds[arr[i]]!) { kitty in
                        NavigationLink {
                           KittyDetailsView(
                            stats: KittyBreed(fromCoreData: kitty.stats),
                            pfp: KMKSwiftUIStyles.i.KMKDataTransformUIImage(using: kitty.pfp),
                            name: kitty.name!,
                            birthday: kitty.birthday,
                            delegate: self.model, id: kitty.objectID)
                        } label: {
                            Text(kitty.name!)
                        }
                    }
                    
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: arr[i])
                }
            }
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
