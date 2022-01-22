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
    
    
    func fetchKittiesPlayingWithToys() -> Results<UnownedKittyInPlayground> {
        return realm.objects(UnownedKittyInPlayground.self)
    }

    func fetchKitties() -> Results<KittyRealm> {
        return realm.objects(KittyRealm.self)
    }
    
    func sortKittiesTimely(sort: Bool, kitties: Results<KittyRealm> ) -> Results<KittyRealm>{
        return kitties.sorted(byKeyPath: "birthday", ascending: sort)
    }
    
    func storePossibleKittiesInBackground(stats:KittyBreed, urls: [String], toys: Set<ToyType>) {
        do{
            try realm.write {
                let newStats = KStatsRealm();
                let newKitty = UnownedKittyInPlayground();

                
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
                newStats.intelligence = stats.intelligence
                
                
                
                newKitty.statsLink = newStats;
                urls.forEach { url in
                    newKitty.imgurls.append(url)
                }
                toys.forEach { toy in
                    newKitty.toysInteracted.append(toy.rawValue)
                }
                realm.add(newKitty)
                
            }
        }
        catch let err {
            print("counld not add todoey to list in realm",err.localizedDescription)
        }
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
                newStats.intelligence = stats.intelligence
                
                
                
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
    
    func deleteAllUnownedKitties() {
        do{
            try realm.objects(UnownedKittyInPlayground.self).forEach { oops in
                try realm.write {
                    realm.delete(oops)
                }
            }
        }
        catch let e {
            print(e.localizedDescription)
        }
    }


   
    func deleteWanderingItemWithRealm(ref: UnownedKittyInPlayground){
        do{
            try realm.write {
                realm.delete(realm.objects(UnownedKittyInPlayground.self).filter("uid=%@",ref.uid))
            }
        }
        catch let e {
            print(e.localizedDescription)
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
}
