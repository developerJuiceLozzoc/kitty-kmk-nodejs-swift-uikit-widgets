//
//  CoreData.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import CoreData
import UIKit

class CoreData {
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchKitties() -> [Kitty]? {
        
        let context = persistentContainer.viewContext
        
        let request: NSFetchRequest<Kitty> = Kitty.fetchRequest()
        do{
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
