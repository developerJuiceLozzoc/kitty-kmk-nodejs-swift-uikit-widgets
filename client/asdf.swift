//
//  asdf.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/21/22.
//

import Foundation


var notificationsStorage: [String: [String: [(String, Any) -> Void]]]

notificationsStorage[className][notificationName].append(observer)


for (notificationName, closures) in notificationData {
            // Check if the notification name matches
    guard notificationName == name else { continue }
    for closure in closures {
        atLeastOneNotificationFound = true
        closure(name, object)
    }
}

guard let notifications = notificationsStorage[notificationName] else {return}


func addObserver(_ _class: AnyClass, name: String, closure: @escaping (String, Any) -> Void) {
