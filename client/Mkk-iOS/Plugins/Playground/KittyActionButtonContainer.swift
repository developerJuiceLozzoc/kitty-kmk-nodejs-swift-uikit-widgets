//
//  KittyActionButtonContainer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI
import RealmSwift
import Firebase

struct KittyActionButtonContainer: View {
    @ObservedResults(UnownedKittyInPlayground.self, sortDescriptor:
        SortDescriptor(keyPath: "uid", ascending: true))
        var wanderingKitties
    @State var ds: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [])
    @State var reference: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [])
    @State var showWanderingKittiesRecap: Bool = false
    @State var backgroundNotificationClearDidFail = false
    @State var currentAlertType: KMKAlertType = .removeNotifFailureBackground
    @State var showTutorial = false
    
    var model = KittyPlistManager()
    var network: KittyJsoner = KittyJsoner()
    let realmModel = RealmCrud()
    
    func registerForNotifications() {
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            UNUserNotificationCenter.current().delegate = delegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions){ authorized, error in
                if authorized {
                    guard let DeviceToken = UserDefaults.standard.string(forKey: "FCMDeviceToken") else { return }
                    DispatchQueue.global().async {
                        dispatchPushRegistration(with: DeviceToken)

                    }
                }
            }
        }
        
    }
    
    func dispatchPushRegistration(with token: String) {
        
            network.postNewNotification(withDeviceName: token) { (result) in
                switch result {
                    case .success(_):
                    currentAlertType = .succRegisterForPush
                    backgroundNotificationClearDidFail.toggle()
                    if ZeusToggles.shared.toggles.instantPushKitty {
                        network.dispatchNotificationsImmediately { result in
                            switch result {
                            case .success( _):

                                return
                            case .failure(let err):
                                print(err)
                                }
                        }
                    }
                    case .failure(_):
                    currentAlertType = .failedRegisterForPush
                    backgroundNotificationClearDidFail.toggle()
                }
            }
    }
    
    func tryDeleteNotification() {
        guard let nid = KittyPlistManager.getNotificationToken() else {return}
        network.deleteOldNotification(id: nid, with: "adopted") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    ds.toys = []
                    KittyPlistManager.removeNotificationToken()
                default:
                    currentAlertType = .removeNotifFailureBackground
                    backgroundNotificationClearDidFail.toggle()

                }
            }
        }
        
    }
    var body: some View {
        VStack {
            HStack(spacing: 21){
                VStack {
                    PourWaterTile(store: $ds)
                    Spacer()
                }
                VStack {
                    Spacer()
                    FoodBowlTile(store: $ds)
                    UseToyTile(store: $ds, onSheetDisappear: {
                        guard ds != reference else {return}
                        
                        if ds.toys.isEmpty {
                            tryDeleteNotification()
                        }
                        if !ds.toys.isEmpty &&
                                KittyPlistManager.getNotificationToken() == nil &&
                            ZeusToggles.shared.didLoad {
                            if model.SaveItemFavorites(items: ds){
                                registerForNotifications()
                            }
                        }
                    })
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: PourWaterTile.tileHeight + 75)
            .onAppear {
                if let store = model.LoadItemFavorites() {
                    ds = store
                    reference = ds
                }
                else {
                    print("there is no store")
                    ds = KittyPlaygroundState(foodbowl: 1, waterbowl: 1, toys: [])
                    reference = ds
                }
                
                if !ZeusToggles.shared.hasReadTutorialCheck() {
                    showTutorial.toggle()
                }
            }
            .onDisappear {
                if ds != reference && wanderingKitties.count == 0 {
                    if model.SaveItemFavorites(items: ds) {
                        reference = ds
                    }
                    else {
                        ds = reference // restore changes?
                        print("something went wrong saving preferences")
                    }
                }
            }
            
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
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                        .foregroundColor(Color("ultra-violet-1"))
                        .onTapGesture {
                            showTutorial.toggle()
                        }
                }
                Spacer()
            }
        )
        .popover(isPresented: $showTutorial, content: {
            if #available(iOS 15.0, *) {
                TutorialPopup()
                    .textSelection(.enabled)
                    .onDisappear {
                        ZeusToggles.shared.setHasReadTutorial()
                    }
            } else {
                TutorialPopup()
                    .onDisappear {
                        ZeusToggles.shared.setHasReadTutorial()
                    }
            }
           
        })
        .alert(isPresented: $backgroundNotificationClearDidFail) {
            KMKSwiftUIStyles.i.renderAlertForType(type: currentAlertType)
        }
        .sheet(isPresented: $showWanderingKittiesRecap, onDismiss: nil) {
            WhileYouWereAwayAlert(ds: ds)
        }
        
    }
}

struct KittyActionButtonContainer_Previews: PreviewProvider {
    static var previews: some View {
        KittyActionButtonContainer(ds: KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: 0, type: .chewytoy, hits: 10)]))
    }
}
