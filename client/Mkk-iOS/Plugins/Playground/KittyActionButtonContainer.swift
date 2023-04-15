//
//  KittyActionButtonContainer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI
import Firebase
import CoffeeToast

struct KittyActionButtonContainer: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var deeplink: KMKDeepLink
    @StateObject var networkManager = ToyNetworkManager()
    
    @State var ds: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [], subscription: "")
    @State var reference: KittyPlaygroundState = KittyPlaygroundState(foodbowl: -1, waterbowl: -1, toys: [], subscription: "")
    // action to show error that might happen on the client
// idk maybe i should look into a toast
    @State var backgroundNotificationClearDidFail = false
    @State var currentAlertType: KMKAlertType = .removeNotifFailureBackground
    @State var showTutorial = false
    @State var wanderingKittiesisEmpty: Bool = true
    private var marginSpacing: String {
        let chars = (0...5).map { _ in " " }.joined(separator: "\t")
        return chars
    }

    var refreshCheck: () -> Bool
    var model = KittyPlistManager()
    var network: KittyJsoner = KittyJsoner()
//    let realmModel = RealmCrud()
    
    func viewDidAppear() {
        wanderingKittiesisEmpty = self.refreshCheck()
        if let store = model.LoadItemFavorites() {
            ds = store
            reference = ds
        }
        else {
            ds = KittyPlaygroundState(foodbowl: 1, waterbowl: 1, toys: [], subscription: "")
            reference = ds
        }
        
        if !ZeusToggles.shared.hasReadTutorialCheck() {
            showTutorial.toggle()
        }
    }
    
    func viewDidDisappear() {
        if ds != reference && wanderingKittiesisEmpty {
            if model.SaveItemFavorites(items: ds) {
                reference = ds
            }
            else {
                ds = reference // restore changes?
                print("something went wrong saving preferences")
            }
        }
    }
    func handlePossibleSubscription() {
        let addedNewToys = reference.toys.count > 0
        let addedFreshToys = reference.toys.count == 0
        let hasToysOut = !ds.toys.isEmpty
        guard hasToysOut, ZeusToggles.shared.didLoad else {return}
        let dg = DispatchGroup()
        if KittyPlistManager.getNotificationToken() != nil &&
            addedFreshToys || addedNewToys {
            // verify that our subscription is active
            dg.enter()
            network.retreiveDocumentTokenForScheduledPushIfExists { result in
                defer { dg.leave() }
                switch result {
                    // do not do anything because i guess this is fine, we are continuing our
                // subscription
                    case .success(let token):
                        if addedNewToys {
                            print("TOYMODAL - added more toys, confirming that we already had a ducument")
                        } else if addedFreshToys {
                            print("TOYMODAL - added new toys but already had a subscription?")
                        }
                    case .failure(let error):
                    //
                    print(error)
                        print("TOYMODAL - we did not have a token? idk")
                    
                }
                
                //possibly store one or two lurking kittins into core data immediately right now
                //so that if they visit again in 20 minutes they are here.
                 
            }
   
        }
        else {
            if addedNewToys {
                print("TOY_MODEL i wonder what happend to our token since we already had one.")
            }
            dg.enter()
            DispatchQueue.main.async {
                network.postNewNotification() { result in
                    defer { dg.leave() }
                    switch result {
                    case .success(let token):
                        KittyPlistManager.setNotificationToken(with: token)
                        ds.subscription = token
                        
                        break
                    case .failure(let error):
                        break
                    }
                }
            }
            
            
        }
        
        
        // or create new subscription or reset.
        //not sure, unless we had toys previously.
        dg.notify(queue: .main) {
            return
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
                    UseToyTile(tnm: networkManager, store: $ds, onSaveToys: {
//                        update the playground if modified
                        guard ds != reference else {return}
                        let playgroundPersistDidFail = model.SaveItemFavorites(items: ds)
                        if playgroundPersistDidFail {
                            print("CDM - failed to save persisted playground")
                        }
                        if ds.toys.isEmpty {
                            networkManager.tryDeleteNotification { result in
                                switch result {
                                case .success(_):
                                    ds.toys = []
                                    currentAlertType = .noneError
                                case .failure(.notificationServerError):
                                    currentAlertType = .removeNotifFailureBackground
                                default:
                                    currentAlertType = .failedRegisterForPush
                                    backgroundNotificationClearDidFail.toggle()

                                }
                            }
                            return
                        }
                        handlePossibleSubscription()
                    }, onSheetDisappear: {
                        if currentAlertType != .noneError {
                            backgroundNotificationClearDidFail.toggle()
                        }
                    })
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: PourWaterTile.tileHeight + 75)
            .onAppear {
                self.viewDidAppear()
            }
            .onDisappear {
                self.viewDidDisappear()
            }
            
            if !wanderingKittiesisEmpty  || backgroundNotificationClearDidFail {
                Spacer()
            }
            
            ZStack {
                if !wanderingKittiesisEmpty {
                    KMKCustomSwipeUp(content: {
                        VStack {
                            Text("You have cats waiting by your toys!")
                            Text("Swipe up to view")
                        }
                        
                    }, gestureActivated: $deeplink.showWanderingKittyRecap)
                }
                
               
                Toast("\(marginSpacing)\(marginSpacing)\(marginSpacing)",
                          duration: 4.75, isShown: $backgroundNotificationClearDidFail) {
                        Text("")
                }
                .offset(x: 0, y: backgroundNotificationClearDidFail ? 0 : 100)
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
        .sheet(isPresented: $deeplink.showWanderingKittyRecap, onDismiss: nil) {
            WhileYouWereAwayAlert()
                .environment(\.managedObjectContext, managedObjectContext)
        }
        
    }
}

struct KittyActionButtonContainer_Previews: PreviewProvider {
    static var deepLink = KMKDeepLink()

    static var previews: some View {
        KittyActionButtonContainer( ds: KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: 0, type: .chewytoy, hits: 10)], subscription: ""), refreshCheck: { return false })
            .environmentObject(deepLink)
    }
}
