//
//  ListKittiesSwiftui.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/20/21.
//

import SwiftUI

let dummylist = ListKittiesDataSource(
    content: [
        [(name: "Name 1", id:"0")],
        [(name: "Name 1", id:"1")],
    [(name: "Saint Charles 3rd", id:"2"),
     (name: "St. Vincent", id:"3"),
     (name: "HEHEHEEHEAHAHAAHAH", id:"0")]
    ],
    sections: ["Breed number 1", "Breed 2", "BREEEDSUPERDUPER"])


struct ListKittiesView: View {
    @EnvironmentObject var ds: ListKittiesDataSource
    @State var showTutorial = false
    var onKittyClick: ((String) -> Void)?
    var body: some View {
        List {
            Section {
                ScrollView {
                    List {
                        
                    }
                }.frame(height: UIScreen.main.bounds.height/4)
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Accessed")
            }
            
            Section {
                ScrollView {
                    List {
                        
                    }
                }.frame(height: UIScreen.main.bounds.height/4)
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Recently Adopted")
            }
            
            ForEach(0..<ds.sectionTitleDataSource.count){ i in
                Section(header: KMKSwiftUIStyles.i.renderSectionHeader(with:ds.sectionTitleDataSource[i])) {
                    ForEach(0..<ds.contentDataSource[i].count) { j in
                    CatListRowItem(name: ds.contentDataSource[i][j].name)
                        .onTapGesture {
                            onKittyClick?(ds.contentDataSource[i][j].id)
                        }
                        
                    }
                }
            }
        }
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    Image("questionmark.circle")
                        .resizable()
                        
                        .frame(width: 30, height: 30)
                        .padding()
                        .onTapGesture {
                            showTutorial.toggle()
                        }
                }
                Spacer()
            }
        )
        .popover(isPresented: $showTutorial, content: {
            if #available(iOS 15.0, *) {
                ListTutorialPopup()
                    .textSelection(.enabled)
                    .onDisappear {
                        ZeusToggles.shared.setHasReadListTutorial()
                    }
            } else {
                ListTutorialPopup()
                    .onDisappear {
                        ZeusToggles.shared.setHasReadListTutorial()
                    }
            }
        })
        .onAppear {
            if !ZeusToggles.shared.hasReadListTutorialCheck() {
                showTutorial.toggle()
            }
        }
    }
}

struct ListKittiesSwiftui_Previews: PreviewProvider {
    static var previews: some View {
        ListKittiesView().environmentObject(dummylist)
    }
}
