//
//  WanderingKittyViewModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/24/22.
//
import UIKit
import SwiftUI
import CoreData


class WanderingKittyViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var kitties: [WanderingKitty] = []
    var hasLoaded = false
    init() {
        container = NSPersistentContainer(name: "Model")
    }
    
    private func loadKitties() {
        let moc = self.container.viewContext
        let request: NSFetchRequest<WanderingKitty> = WanderingKitty.fetchRequest()
        do{
            self.kitties = try moc.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func update() {
        if !hasLoaded {
            container.loadPersistentStores { [weak self] description, e in
                guard let self = self else {return}
                if let error = e {
                    fatalError("Error: \(error.localizedDescription)")
                }
                else {
                    self.hasLoaded.toggle()
                    self.loadKitties()
                }
            }
        } else {
            loadKitties()
        }
        
    }

}
