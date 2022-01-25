//
//  ListKittiesSwiftui.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/20/21.
//

import SwiftUI
import UIKit
import RealmSwift

//struct ListKittiesWithContent: View {
//    var body: some View {
//
//    }
//}

struct ListKittiesView: View {

    @ObservedObject var presenter = ListKittiesPresenter()
    @Binding var showTutorial: Bool
    @State var shouldShowFilter: Bool = false
    @State var listFilter: ListKittyFilter = ListKittyFilter(grouping: .date, sortOrder: .rand)

    @State private var refreshID = UUID()
    let didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        ZStack {
            if presenter.isKittyListEmpty {
                presenter.presentNoKittiesScreen()
                    .onAppear {
                        presenter.updateIsEmpty()
                    }
            }
            else if listFilter.grouping == .date {
                presenter.presentGroupedDateList(sortOrder: listFilter.sortOrder)
                    .id(refreshID)
                          .onReceive(self.didSave) { _ in   //the listener
                              self.refreshID = UUID()
                              print("generated a new UUID")
                          }
            } else if listFilter.grouping == .breeds {
                presenter.presentGroupedBreedsList(with: listFilter.sortOrder)
                .id(refreshID)
                      .onReceive(self.didSave) { _ in   //the listener
                          self.refreshID = UUID()
                          print("generated a new UUID")
                      }
            } else if listFilter.grouping == .atoz {
                presenter.presentAlphabeticalList(sortOrder: listFilter.sortOrder)
                    .id(refreshID)
                      .onReceive(self.didSave) { _ in   //the listener
                          self.refreshID = UUID()
                          print("generated a new UUID")
                      }
            }
        }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shouldShowFilter.toggle()
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("ultra-violet-1"))
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showTutorial.toggle()
                }, label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("ultra-violet-1"))
                })
            }
        }
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
