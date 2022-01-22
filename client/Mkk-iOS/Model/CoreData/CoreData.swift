//
//  CoreData.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import CoreData
import UIKit

class KMKCoreData {
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContextDidFail () -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return false
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror)")
                return true
            }
        }
        return false
    }
    
    func fetchKitties(sortBy field: String, sortOrder: KittySortOrderType) -> [Kitty] {
        let moc = persistentContainer.viewContext
        let request: NSFetchRequest<Kitty> = Kitty.fetchRequest()
        if sortOrder == .ascend || sortOrder == .descend {
            let ascending = sortOrder == .ascend
            request.sortDescriptors = [NSSortDescriptor(key: field, ascending: ascending)]
        }
     
        do {
            let results = try moc.fetch(request)
            if sortOrder == .rand {
                return results.shuffled()
            } else {
                return results
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func ownedKittiesIsEmpty() -> Bool {
        let moc = persistentContainer.viewContext
        let request: NSFetchRequest<Kitty> = Kitty.fetchRequest()
        do{
            return try moc.fetch(request).isEmpty
        } catch {
            return true
        }
    }
    
    func updateKittyLastAccesed(using id: String ) -> Bool {
        let date = Date().timeIntervalSince1970
        let moc = persistentContainer.viewContext
        let request: NSFetchRequest<Kitty> = Kitty.fetchRequest()
        request.predicate = NSPredicate(format: "id == @", id)
        do{
            let k = try moc.fetch(request)
            guard k.count > 0 else {return false}
            k[0].dateLastAccessed = date
            return !saveContextDidFail()
        } catch {
            return false
        }
    }
    
    func createKStats(using stats: KittyBreed) -> KStats {
        let moc = persistentContainer.viewContext
        let kstats = NSEntityDescription.insertNewObject(forEntityName: "KStats", into: moc) as! KStats
        kstats.name = stats.name
        kstats.kitty_description = stats.description
        kstats.breed_id = stats.id
        kstats.dog_friendly = Int16(stats.dog_friendly)
        kstats.intelligence = Int16(stats.intelligence)
        kstats.stranger_friendly = Int16(stats.stranger_friendly)
        kstats.shedding_level = Int16(stats.shedding_level)
        kstats.energy_level = Int16(stats.energy_level)
        kstats.life_span = stats.life_span
        kstats.magic_level = Int16.random(in: 0...5)
        kstats.origin = stats.origin
        return kstats
    }
    
    func createKitty(using stats: KittyBreed,name: String,toys: [ToyType], pfp: Data?) -> Bool {
        let moc = persistentContainer.viewContext
        let kitty = NSEntityDescription.insertNewObject(forEntityName: "Kitty", into: moc) as! Kitty
        
        
        kitty.stats = createKStats(using: stats)
        kitty.birthday = Date().timeIntervalSince1970
        kitty.dateLastAccessed = Date().timeIntervalSince1970
        kitty.pfp = pfp
        kitty.name = name
        let toysAsString: String = toys.description
        let toyData = toysAsString.data(using: String.Encoding.utf16)
        kitty.toysInteracted = toyData
        return saveContextDidFail()
    }
    func createWanderingKitty(id: String, urls: [String], toys: [ToyType], stats: KittyBreed) -> Bool {
        let moc = persistentContainer.viewContext
        let wanderingk = NSEntityDescription.insertNewObject(forEntityName: "WanderingKitty", into: moc) as! WanderingKitty
        wanderingk.stats = createKStats(using: stats)
        
        let toysAsString: String = toys.description
        let toyData = toysAsString.data(using: String.Encoding.utf16)
        wanderingk.toysInteracted = toyData
        
        let urlsAsString: String = urls.description
        let urlData = urlsAsString.data(using: String.Encoding.utf16)
        wanderingk.toysInteracted = urlData
        
        wanderingk.breed_id = id
        
        return saveContextDidFail()
        
        
    }
    
    
    
}
