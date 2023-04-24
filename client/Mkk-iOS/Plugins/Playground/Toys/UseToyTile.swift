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
    @State var showToyMenu = false
    @State var shouldShowWanderingModelInstead: Bool = false
    @State var alert = AlertText(title: "", message: "")
    @State var helppop = false
    var onSaveToys: () -> Void
    var onSheetDisappear: () -> Void

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
        .knobby(isPresented: $showToyMenu, onDismiss: onSheetDisappear) {
            ToyItemSheet(updateFlag: $showToyMenu, tnm: tnm, store: $store, onSaveToys: onSaveToys)
        }
    }
   

}

struct ToyItemSheet: View {
    let colums: [GridItem] = Array.init(repeating: .init(.fixed((UIScreen.main.bounds.width-10)/3)), count: 3)
    let ALL_TOYS: [ToyType] = ToyType.allCases.map { return $0 }.filter { return $0 != .unknown   }
    @Binding var updateFlag: Bool
    @ObservedObject var tnm: ToyNetworkManager
    @Binding var store: KittyPlaygroundState
    
    @State var shouldShowAlertNoMoreNotifications = false
    var onSaveToys: () -> ()
    
    var currentSubscriptionValid: Bool {
        
        store.toys.count > 0 && containsNotification() != nil
    }
    var heightConsideringClearButton: CGFloat {
        let mainHeight = UIScreen.main.bounds.height
        if currentSubscriptionValid {
            return 0.40 * mainHeight
        } else {
            return 0.45 * mainHeight
        }
    }
//    var journalButtonDimensions
    func containsNotification() -> String? {
        return KittyPlistManager.getNotificationToken()
    }
    
    func clearUpPlayground() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            tnm.explicitClearNotification() { result in
                switch result {
                case .success(_):
                    store.subscription = ""
                    break
                case .failure(_):
                    break
                }
            }
        }
    }

    var  body: some View {
        ScrollView {
            if currentSubscriptionValid {
                Section {
                    KMKLongPressYellow(
                        buttonTitle: "Press and hold to confirm unsubcription",
                        onLongPress: clearUpPlayground
                    )
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
                .overlay(
                    KMKSwiftUIStyles.i.renderDashboardTileBorder())
                .padding([.trailing,.leading], 7)
            }
            else {
                Text("")
                    .frame(height:20)
            }
            if !store.toys.isEmpty {
            ScrollView {
                
                    Section {
                         ForEach(store.toys, id: \.self) {
                             ToyItumListView(ds: $0 )
                         }
                     } header: {
                         KMKSwiftUIStyles.i.renderSectionHeader(with: "Current toys in use on site")
                             .padding(.top, 50)
                     }
            }
            .overlay(
                KMKSwiftUIStyles.i.renderDashboardTileBorder())
            .frame(height:  heightConsideringClearButton)
            .padding([.trailing,.leading], 7)
        }
            
            Spacer()
                .overlay(
                    KMKSwiftUIStyles.i.renderDashboardTileBorder())
                .frame(height:  UIScreen.main.bounds.height*0.05)
                .padding([.trailing,.leading], 7)
            ScrollView {
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
            .frame(height: UIScreen.main.bounds.height * 0.3)
            Divider()
            Spacer()
            HStack {
                Spacer()
                Button {
                    onSaveToys()
                    updateFlag.toggle()
                } label: {
                    EmptyView()
                }.buttonStyle(StateableButton(change: { state in
                    return Text("Save entry \n in journal")
                        .background(
                            KMKSwiftUIStyles.i.renderSelectableTileBG(isSelected: state)
                        )
                        .foregroundColor(
                            !state ? Color("ultra-violet-1") : Color("form-label-color"))
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .lineSpacing(10)
                        .lineLimit(10)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth:1)
                                .foregroundColor(Color("ultra-violet-1"))
                        )
                        .frame(width: 300, height: 100)
                        
                }))
                Spacer()
            }
        }
        .onAppear {
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
        
        
        
    }
}

struct UseToyTileToyItemSheet_Previews: PreviewProvider {
    @State static var value = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 10)], subscription: "")
    @State static var flag: Bool = true

    static var previews: some View {
        Group {
            UseToyTile(tnm: ToyNetworkManager(), store: $value,
                onSaveToys: {
                
            }, onSheetDisappear: {}
            ).preferredColorScheme(.dark)
            ToyItemSheet(updateFlag: $flag, tnm: ToyNetworkManager(), store: $value) {
                print("saving toys")
            }
        }

    }
}
