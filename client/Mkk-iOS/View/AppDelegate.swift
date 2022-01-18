//
//  AppDelegate.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/12/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var wkm: WanderingKittyModel = WanderingKittyModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        
        KittyJsoner().fetchRemoteFeatureToggles { result in
            switch(result) {
            case .success(let toggles):
                ZeusToggles.shared.toggles = toggles
                ZeusToggles.shared.didLoad = true
            case .failure(let e):
                print(e)
                ZeusToggles.shared.didLoad = true

            }
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dict = userInfo["aps"] as! NSDictionary
        print(dict)

      // Print full message.
      print("foreground push",userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

func getRootTabController() -> UITabBarController? {
    guard let scene = UIApplication.shared.connectedScenes.first, let sD = scene.delegate as? SceneDelegate else {return nil}
    return sD.window?.rootViewController as? UITabBarController
}



func getRootNavFromTabController(from controller: UITabBarController, on tab: Int) -> UINavigationController? {
    controller.selectedIndex = tab
    return controller.selectedViewController as? UINavigationController
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      
//      guard userInfo["ADD_KITTY"] as? NSString != nil else {return}
      completionHandler([[.banner,.list, .sound]])

  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if userInfo["ADD_KITTY"] as? NSString != nil {

        guard let nid = userInfo["NOTIFICATION_ID"] as? String else{ completionHandler();return;}
        KittyPlistManager.setNotificationToken(with: nid)
        var breeds: [String] = []
        for _ in 0..<Int.random(in: 1...3) {
            breeds.append(KITTY_BREEDS.randomElement() ?? "ycho")
        }
            
        wkm.retrieveAndStoreKitties(with: breeds)
    
        DispatchQueue.main.async {
            getRootTabController()?.selectedIndex = 0
        }
            
    }


    completionHandler()
  }
}



extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let prevToken = UserDefaults.standard.value(forKey: "FCMDeviceToken") as? String {
            if fcmToken != prevToken {
                print("--FCM Updating FCMToken first time")
                UserDefaults.standard.setValue(fcmToken, forKey: "FCMDeviceToken")
            }
        }
        else{
            print("--FCM Saving FCMToken first time")
            UserDefaults.standard.setValue(fcmToken, forKey: "FCMDeviceToken")
        }
    

    }
}
