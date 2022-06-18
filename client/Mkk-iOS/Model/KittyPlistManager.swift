//
//  KittyPlistManager.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/28/21.
//

import Foundation



class KittyPlistManager {
    let ItemFavoritesFilePath = "ItemFavorites.plist"
    
    
    static func removeNotificationToken() {
        UserDefaults.standard.removeObject(forKey: "current-notification-event")
    }
    static func setNotificationToken(with str: String) {
        UserDefaults.standard.set(str, forKey: "current-notification-event")

    }
    static func getNotificationToken() -> String? {
        return UserDefaults.standard.string(forKey: "current-notification-event")
    }

    func LoadItemFavorites() -> KittyPlaygroundState?
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let docuDir = paths.firstObject as! String
        let path = "\(docuDir)/\(ItemFavoritesFilePath)"
        let dict = NSDictionary(contentsOfFile: path)
  
        var toysPreviously: [ToyItemUsed] = []
        
        guard
            let foodInBowlValue = dict?.object(forKey: "foodbowl") as? Int,
            let waterInBowlAmnt = dict?.object(forKey: "waterbowl") as? Int else {
            return nil
        }
        
        
        if let arrayitems = dict?.object(forKey: "toys") as? NSArray
        {
            for i in 0..<arrayitems.count {
                guard let itemDict = arrayitems[i] as? NSDictionary else { continue }
    
                let toy = ToyItemUsed(dictionary: itemDict)
                if toy.type != .unknown {
                    toysPreviously.append(toy)
                }
        
            }
        }
        
        return KittyPlaygroundState(foodbowl: foodInBowlValue, waterbowl: waterInBowlAmnt, toys: toysPreviously)
    }
    func SaveItemFavorites(items : KittyPlaygroundState) -> Bool
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let docuDir = paths.firstObject as! String
        let path = "\(docuDir)/\(ItemFavoritesFilePath)"
        let filemanager = FileManager.default

        let array: [NSMutableDictionary] = items.toys.map { toy in
            let dict = NSMutableDictionary()
            dict["timesInteracted"] = toy.timesInteracted
            dict["type"] = toy.type.rawValue
            dict["dateAdded"] = toy.dateAdded
            return dict
        }
        let dict = NSMutableDictionary()
        dict.setObject(items.foodbowl, forKey: "foodbowl" as NSCopying)
        dict.setObject(items.waterbowl, forKey: "waterbowl" as NSCopying)
        dict.setObject(array, forKey: "toys" as NSCopying)

        
        //check if file exists
        if(!filemanager.fileExists(atPath: path))
        {
            let created = filemanager.createFile(atPath: path, contents: nil, attributes: nil)
             if(created)
             {
                 let succeeded = dict.write(toFile: path, atomically: true)
                 return succeeded
             }
             return false
        }
        else
        {
            let succeeded = dict.write(toFile: path, atomically: true)
            return succeeded
        }
    }

}
