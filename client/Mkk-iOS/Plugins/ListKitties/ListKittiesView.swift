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

    let presenter = ListKittiesPresenter()
    @Binding var showTutorial: Bool
    @State var shouldShowFilter: Bool = false
    @State var listFilter: ListKittyFilter = ListKittyFilter(grouping: .date, sortOrder: .rand)
    
    var body: some View {
        if presenter.isKittyListEmpty {
            Text("Sorry you have no cats yet")
        }
        else if listFilter.grouping == .date {
            VStack{
                
            }
        } else if listFilter.grouping == .breeds {
            List {
                
            }
        } else {
            List {
                
            }
        }
        EmptyView()
            .sheet(isPresented: $shouldShowFilter) {
            } content: {
                ListKittyFilterView(isPresented: $shouldShowFilter, filter: listFilter) { f in
                    self.listFilter = f
                }
            }
        .onAppear {
            if !ZeusToggles.shared.hasReadListTutorialCheck() {
                showTutorial.toggle()
            }
        }
        .navigationTitle(Text("List Of Cats"))
    }
}

struct ListKittiesSwiftui_Previews: PreviewProvider {
    @State static var el: Bool = false
    static var previews: some View {
        NavigationView {
            ListKittiesView(showTutorial: $el)

        }
    }
}
