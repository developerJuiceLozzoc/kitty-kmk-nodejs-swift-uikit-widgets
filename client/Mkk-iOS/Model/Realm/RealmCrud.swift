//
//  RealmCrud.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/12/21.
//

import UIKit

import RealmSwift

class RealmCrud {
    let realm = try! Realm()

    func fetchKitties() -> Results<KittyRealm> {
        return realm.objects(KittyRealm.self)
    }
    
    func sortKittiesTimely(sort: Bool, kitties: Results<KittyRealm> ) -> Results<KittyRealm>{
        return kitties.sorted(byKeyPath: "birthday", ascending: sort)
    }
    
    func addTodooeyToRealm(name: String, stats: KittyBreed,imgurl: String,imgdata: Data){

        do{
            try realm.write {
                let newPhoto = KPhotoRealm();
                let newStats = KStatsRealm();
                let newKitty = KittyRealm();

                newPhoto.imgurl = imgurl;
                newPhoto.img = imgdata
                
                newStats.breedid = stats.id
                newStats.name = stats.name
                newStats.temperament = stats.temperament
                newStats.kitty_description = stats.description
                newStats.life_span = stats.life_span
                newStats.dog_friendly = stats.dog_friendly
                newStats.energy_level = stats.energy_level
                newStats.shedding_level = stats.shedding_level
                newStats.stranger_friendly =   stats.stranger_friendly
                newStats.origin = stats.origin
                
                
                
                newKitty.photoLink = newPhoto;
                newKitty.statsLink = newStats;
                newKitty.name = name;
                
                realm.add(newKitty)
                
            }
        }
        catch let err {
            print("counld not add todoey to list in realm",err.localizedDescription)
        }

    }


   

    func deleteItemWithRealm(ref: KittyRealm){
        do{
            try realm.write {
                realm.delete(ref)
            }
        }
        catch let e {
            print(e.localizedDescription)
        }
        
    }
    func dangerousStuffDatabase(){
        let names = [
            "Salem",    "Snuggles", "Shadow",
            "Cookie",   "Dusty",    "Willow",
            "Cali",     "Scooter",  "Oliver",
            "Milo",     "Muffin",   "Bubba",
            "Whiskers", "Lola",     "Bubba",
            "Leo",      "Boo",      "Snuggles",
            "Leo",      "Felix",    "Sassy",
            "Gizmo",    "Baby",     "Bubba",
            "Callie",   "Snowball", "Oreo"
          ]
        guard let path = Bundle(for: Self.self).path(forResource: "breeds", ofType: "json") else { return; }
        let fileURL = URL(fileURLWithPath: path)
        do{
            let data = try Data(contentsOf: fileURL);
            let swiftkitty = try JSONDecoder().decode([KittyBreed].self, from: data)
            for name in names {
                if let breed = swiftkitty.randomElement(), let url = breed.image?.url, let iurl = URL(string: url) {
                    URLSession.shared.dataTask(with: iurl){ data,_,_ in
                        if let imgdata = data {
                            DispatchQueue.main.async {
                                self.addTodooeyToRealm(name: name, stats: breed, imgurl: url,imgdata: imgdata)
                            }
                            
                        }
                        
                    }.resume()
                    
                }

            }
        }
        catch let err{
            print(err)
        }
    }
}
