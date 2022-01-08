//
//  KittyActionButtonContainer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI
import RealmSwift

struct KittyActionButtonContainer: View {
    @ObservedResults(UnownedKittyInPlayground.self, sortDescriptor:
        SortDescriptor(keyPath: "uid", ascending: true))
        var wanderingKitties
    @State var ds: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [])
    @State var reference: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [])
    @State var showWanderingKittiesRecap: Bool = false
    
    var model = KittyPlistManager()
    let realmModel = RealmCrud()
    
    var body: some View {
        VStack{
            HStack(spacing: 21){
                VStack {
                    PourWaterTile(store: $ds)
                    Spacer()
                }
                VStack {
                    Spacer()
                    FoodBowlTile(store: $ds)
                    UseToyTile(store: $ds)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: PourWaterTile.tileHeight + 75)
            
            if wanderingKitties.count > 0 {
                Spacer()
                KMKCustomSwipeUp(content: {
                    VStack {
                        Text("You have cats waiting by your toys!")
                        Text("Swipe up to view")
                    }
                    
                }, gestureActivated: $showWanderingKittiesRecap)
                
            }
        }
        .sheet(isPresented: $showWanderingKittiesRecap, onDismiss: nil) {
            WhileYouWereAwayAlert(ds: ds)
        }
        .onAppear {
            guard ds.waterbowl == -1 else { return }
            if let store = model.LoadItemFavorites() {
                ds = store
                reference = ds
            }
            else {
                print("there is no store")
                ds = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [])
                reference = ds
            }
        }
        .onDisappear {
            if ds != reference {
                if model.SaveItemFavorites(items: ds) {
                    reference = ds
                }
                else {
                    ds = reference
                    print("something went wrong saving preferences")
                }
            }
            let network = KittyJsoner()
            if ds.toys.isEmpty, let nid = UserDefaults.standard.string(forKey: "current-notification-event") {
                
                network.deleteOldNotification(id: nid, with: "adopted") { (result) in
                    switch result {
                        default:
                        UserDefaults.standard.removeObject(forKey: "current-notification-event")
                    }
                }
            } else {
                guard
                    let DeviceToken = UserDefaults.standard.value(forKey: "FCMDeviceToken") as? String,
                        UserDefaults.standard.string(forKey: "current-notification-event") == nil,
                    ZeusToggles.shared.didLoad else { return }
                    network.postNewNotification(withDeviceName: DeviceToken) { (result) in
                        switch result {
                            case .success(_):
                            if(ZeusToggles.shared.toggles.instantPushKitty){
                                // post to the server to dilver notification instantly
                                network.dispatchNotificationsImmediately { result in
                                    switch result {
                                    case .success( _):
                                        return
                                    case .failure(let err):
                                        print(err)
                                        }
                                }
                            }
                            case .failure(let e):
                                print(e)
                                
                        }
                    }
                
                
            }
        }
    }
}

struct KittyActionButtonContainer_Previews: PreviewProvider {
    static var previews: some View {
        KittyActionButtonContainer(ds: KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: 0, type: .chewytoy, hits: 10)]))
    }
}
