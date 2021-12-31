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
    var onKittyClick: ((String) -> Void)?
    var body: some View {
        List {
            ForEach(0..<ds.sectionTitleDataSource.count){ i in
                Section(header: KMKSwiftUIStyles.i.renderSectionHeader(with:ds.sectionTitleDataSource[i])) {
                    ForEach(0..<ds.contentDataSource[i].count) { j in
                        if #available(iOS 15.0, *) {
                            KMKSwiftUIStyles.i.renderKittyName(with: ds.contentDataSource[i][j].name)
                                .listRowSeparatorTint(Color("ultra-violet-1"))
                                .listRowBackground(KMKSwiftUIStyles.i.renderListRowBG())
                                .onTapGesture {
                                    onKittyClick?(ds.contentDataSource[i][j].id)
                                }
                                
                        } else {
                            KMKSwiftUIStyles.i.renderKittyName(with: ds.contentDataSource[i][j].name)
                                .listRowBackground(KMKSwiftUIStyles.i.renderListRowBG())
                                .onTapGesture {
                                    onKittyClick?(ds.contentDataSource[i][j].id)
                                }
                                
                        }
                        
                        
                    }
                }
            }
        }
    }
}

struct ListKittiesSwiftui_Previews: PreviewProvider {
    static var previews: some View {
        ListKittiesView().environmentObject(dummylist)
    }
}
