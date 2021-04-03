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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions){ authorized, error in
            if authorized {
                DispatchQueue.main.async{
                    application.registerForRemoteNotifications()
                }
            }
        }
        // special link url here

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
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // Print full message.
    print(userInfo)

    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if let menu = userInfo["ADD_KITTY"] as? NSString {
        guard let scene = UIApplication.shared.connectedScenes.first, let sD = scene.delegate as? SceneDelegate ,let tabController = sD.window?.rootViewController as? UITabBarController else {completionHandler();return;}
        
        tabController.selectedIndex = 2
        guard let vc = tabController.selectedViewController as? UINavigationController else{ completionHandler();return;}
        let jsonifer: CatApier = KittyJsoner()
        if let BREED = KITTY_BREEDS.randomElement() {
            jsonifer.getJsonByBreed(with: BREED) { (result) in
                var json: [KittyApiResults]? = nil
                switch result {
                case .success(let res):
                    json = res
                case .failure(let err):
                    print(err)
                }
                if let saveVC = UIStoryboard
                    .init(name: "ListMyKitties", bundle: nil)
                    .instantiateViewController(identifier: "ConfirmKittyScreen") as? SaveOrDiscardKittyTVC {
                    saveVC.kitty = json
                    vc.pushViewController(saveVC, animated: true)

                }
            }

        }

            
    }


    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    }
}
