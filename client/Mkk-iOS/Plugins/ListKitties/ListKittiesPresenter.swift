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

class ListKittiesPresenter {
    let model = KMKCoreData()
    let isKittyListEmpty: Bool
    
    init() {
        isKittyListEmpty = model.ownedKittiesIsEmpty()
    }
    
    /*
    func gatherDataAndReturn(for filter: KittyListType) -> some View {
        switch filter {
        case .date:
            return presentGroupedDateList(accessed: [], adopted: [])
        default:
            return presentAlphabeticalList()
        }
    }
     */
    func presentNoKittiesScreen() -> some View {
        return VStack {
        
        }
    }
    func presentGroupedDateList() -> some View {
        let accessed: [Kitty] = []
        let adopted: [Kitty] = []
        
        
        return VStack {
            List{
                Section {
                    ForEach(0..<accessed.count, id: \.self) { i in
                        if i < 7 {
                            NavigationLink {
                                Text("wooo")
                            } label: {
                                Text(accessed[i].name!)
                            }
                        }
                    }

                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Accessed")
                }
                Section {
                    ForEach(0..<adopted.count, id: \.self) { i in
                        if i < 7 {
                            NavigationLink {
                               Text("wooh")
//                                detailsViewForKitty(kitty: ownedKittiesAccessed[i])
                            } label: {
                                Text(adopted[i].name!)
                            }
                        }
                    }

                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Adopted")
                }
            }
        }
    }
    
    func presentAlphabeticalList() -> some View {
        return List {
            
        }
    }
    
    
    
}
