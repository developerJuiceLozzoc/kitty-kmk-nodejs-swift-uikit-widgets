//
//  ListKittyFilter.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/21/22.
//

import SwiftUI

struct ListKittyFilter {
    var grouping: KittyListType
    var sortOrder: KittySortOrderType
}



struct ListKittyFilterView: View {
    @Binding var isPresented: Bool
    var filter: ListKittyFilter
    var onSaveChanges: (ListKittyFilter) -> Void
    
    @State var groupingType: Int = 0
    @State var ordering: Int = 0
    var body: some View {
        List {
            Section {
                GroupFilterRadioBox(strings: KittyListType.allCases.map { $0.toString() }, selectedGrouping: $groupingType)
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Grouping")
            }
            Section {
                GroupFilterRadioBox(strings: KittySortOrderType.allCases.map { $0.toString() }, selectedGrouping: $ordering)

            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Ordering")
            } footer: {
                Text("If the filter is") + Text(" Ascending ").bold() + Text("and the grouping is based on") + Text(" words ").bold() + Text("then it will be sorted A - Z, if the filtering is grouped by ") + Text(" dates ").bold() + Text("then it will be sorted past before present.")
            }
            HStack {
                Button {
                    guard let groupEnum = KittyListType(rawValue: groupingType), let sortOrderEnum = KittySortOrderType(rawValue: ordering) else {return}
                    onSaveChanges(ListKittyFilter(grouping: groupEnum, sortOrder: sortOrderEnum))
                    isPresented.toggle()
                } label: {
                    EmptyView()
                }.buttonStyle(StateableButton(change: { state in
                    return Text("Confirm")
                        .bold()
                        .lineLimit(state ? 3 : 2)
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .foregroundColor(Color("radio-button-text"))
                        .padding()
                        .background(state ? Color("emoji-foreground") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth:1)
                                .foregroundColor(Color("ultra-violet-1"))
                        )
                }))
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                   EmptyView()
                }.buttonStyle(StateableButton(change: { state in
                    return Text("Cancel")
                        .bold()
                        .lineLimit(state ? 3 : 2 )
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .foregroundColor(Color("radio-button-text"))
                        .padding()
                        .background(state ? Color("emoji-foreground") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth:1)
                                .foregroundColor(Color("ultra-violet-1"))
                        )
                }))
            }
        }
        .navigationTitle("List Filter")
        .onAppear {
            groupingType = filter.grouping.rawValue
            ordering = filter.sortOrder.rawValue
        }
    }
}

struct ListKittyFilter_Previews: PreviewProvider {
    @State static var el: Bool = false
    static var previews: some View {
        Group {
            NavigationView {
                ListKittyFilterView(isPresented: $el, filter: ListKittyFilter(grouping: .breeds, sortOrder: .ascend)) { _ in }
            }
            NavigationView {
                ListKittyFilterView(isPresented: $el, filter: ListKittyFilter(grouping: .breeds, sortOrder: .ascend)) { _ in }
            }.preferredColorScheme(.dark)
        }
   
    }
}
