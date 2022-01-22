//
//  WanderingKittyModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/1/22.
//

import Foundation


class WanderingKittyModel {
    let realmModel = RealmCrud()
    let coredataModel = KMKCoreData()
    let apiModel: CatApier = KittyJsoner()
    
    
    func retrieveAndStoreKitties(with breeds: [String]) {
        breeds.forEach { breed in
            apiModel.getJsonByBreed(with: breed) { [weak self] (result) in
                guard let wself = self else {return}
                switch result {
                case .success(let res):
                    wself.addStrayCat(cat: res)
                case .failure(let err):
                    print(err)
                }
            }
      }
    }
    
    func addStrayCat(cat: [KittyApiResults]) {
        let plister = KittyPlistManager()
        var playground = plister.LoadItemFavorites()
        let playgroundToys = playground?.toys ?? []
        var toysPlayedWith: Set<ToyType> = []
        var toysPlayedWithHits: [ToyItemUsed] = []
        if playgroundToys.count > 0 {
            let numberOfToysPlayedWith = Int.random(in: 0..<playgroundToys.count)
            for _ in 0..<numberOfToysPlayedWith {
                toysPlayedWith.insert(playgroundToys.randomElement()?.type ?? .unknown)
            }
        }
        playgroundToys.forEach { toy in
            var toyHitsTracked = toy
            if Bool.random() {
                toyHitsTracked.timesInteracted += 1
            } else {
                toyHitsTracked.timesInteracted +=  Int.random(in: 0...5)
            }
            toysPlayedWithHits.append(toyHitsTracked)
        }
        playground?.toys = toysPlayedWithHits
        playground?.foodbowl -= Int.random(in: 25...50)
        playground?.waterbowl -= Int.random(in: 25...66)
        
        if let water = playground?.waterbowl, let food = playground?.foodbowl {
            if water <= 0 {
                playground?.waterbowl = 1
            }
            if food <= 0 {
                playground?.foodbowl = 1
            }
        }
       
        
        guard let breed = cat.first?.breeds.first, let pg = playground else { return }
        let _ = plister.SaveItemFavorites(items: pg)
        
        DispatchQueue.main.async {
            _ = self.coredataModel.createWanderingKitty(id: breed.id, urls: cat.map { return $0.url }, toys: Array.init(toysPlayedWith), stats: breed)
//            self.realmModel.storePossibleKittiesInBackground(stats: breed, urls: , toys: toysPlayedWith)
        }
        
        
    }
    
    
}
