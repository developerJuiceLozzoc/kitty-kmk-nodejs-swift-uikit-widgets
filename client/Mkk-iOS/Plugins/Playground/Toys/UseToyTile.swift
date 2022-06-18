//
//  UseToyTile.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//


import SwiftUI

// i have an array of toys

/*
 when presented with the draw it will alwayss dispaly all the toys
 and indicate when ones are being used at the current moment
 
 
 
 */

//store all the tooys in plist? or only the current ones being selected
struct AlertText {
    var title: String
    var message: String
}



struct UseToyTile: View {
    @ObservedObject var tnm: ToyNetworkManager

    @Binding var store: KittyPlaygroundState
    @State var shouldShowAlertNoMoreNotifications = false
    @State var showToyMenu = false
    @State var shouldShowWanderingModelInstead: Bool = false
    @State var alert = AlertText(title: "", message: "")
    @State var helppop = false
    @State var containsNotification: Bool = false
    var onSheetDisappear: () -> ()
    
    let ALL_TOYS: [ToyType] = ToyType.allCases.map { return $0 }.filter { return $0 != .unknown   }
    

    var body: some View {
        VStack{
            Text("Toys")
        }
        .frame(width: 150, height: 150)
        .background(
            KMKSwiftUIStyles.i.renderDashboardTileBG()
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .onTapGesture(count: 1, perform: {
            showToyMenu.toggle()
        })
        .sheet(isPresented: $showToyMenu, onDismiss: onSheetDisappear) {
            let colums: [GridItem] = Array.init(repeating: .init(.fixed((UIScreen.main.bounds.width-10)/3)), count: 3)
            

            List {
                if store.toys.count > 0 && containsNotification {
                    Section {
                        KMKLongPressYellow(onLongPress: {
                            tnm.explicitClearNotification()
                        })
                        .listRowBackground(Color("suggesting-yellow").opacity(0.25))
                        .alert(isPresented: $shouldShowAlertNoMoreNotifications) {
                            switch tnm.networkState {
                            case .success:
                                return KMKSwiftUIStyles.i.renderAlertForType(type: .removeNotifSuccess)
                            default:
                                return KMKSwiftUIStyles.i.renderAlertForType(type: .removeNotifFailureForeground)
                            }
                        }
                        if tnm.networkState == .loading {
                            Text("Loading... Please wait")
                        }
                        
                    } header: {
                        KMKSwiftUIStyles.i.renderSectionHeader(with: "Clean up toys from area")
                    }
                }
                
                Section {
                    ForEach(store.toys, id: \.self) {
                        ToyItumListView(ds: $0 )
                    }
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Current toys in use on site")
                }
                
                
            }.onAppear {
                
                if tnm.networkState != .idle {
                    switch tnm.networkState {
                    case .success:
                        print("asd")
                    case .failed:
                        print("adf")
                    case .loading:
                        print("asdf")
                    default:
                        return
                    }
                }
            }
            
            LazyVGrid(columns: colums) {
                ForEach(0..<ALL_TOYS.count) {
                    let toy = ALL_TOYS[$0]
                    KMKSwiftUIStyles.i.renderSelectedTile(
                        isSelected: store.toys.contains(where: {$0.type == toy}),
                        text: toy.toString()
                    )
                    .onTapGesture {
                        if store.toys.firstIndex(where: {$0.type == toy}) != nil {
                            store.toys = store.toys.filter({ toyCurrentlyActive in
                                return toyCurrentlyActive.type != toy
                            })
                        } else {
                            store.toys.append(ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: toy, hits: 0))
                        }
                        
                        
                    }
                }
            }           
            
        }

    }

}

struct UseToyTile_Previews: PreviewProvider {
    @State static var value = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 10)])

    static var previews: some View {
        Group {
            UseToyTile(tnm: ToyNetworkManager(), store: $value, onSheetDisappear: {
                
            }).preferredColorScheme(.dark)
        }

    }
}
