//
//  KittyPlagroundHostingController.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/28/21.
//

import UIKit
import SwiftUI
import CoreData

class KMKDeepLink: ObservableObject {
    @Published var showWanderingKittyRecap = false
}


class KittyPlagroundHostingController: UIViewController {
   var deepLink = KMKDeepLink()
    var shouldDisplayNotification: Bool = false
    let container: NSPersistentContainer
    var contentView: KittyActionButtonContainer! /*{
        didSet {
            guard let contentView = self.contentView else {
                return
            }
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        container.loadPersistentStores { [weak self] description, e in
            if let error = e {
                fatalError("Error: \(error.localizedDescription)")
            }
            else {
                guard let self = self else {return}
                
                self.contentView = KittyActionButtonContainer( refreshCheck: self.refreshCheck)
                   
                let contentViewController = UIHostingController(rootView: self.contentView .environment(\.managedObjectContext, self.container.viewContext).environmentObject(self.deepLink) )
                self.addChild(contentViewController)
                self.view.addSubview(contentViewController.view)
                
                contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
                contentViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                contentViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                contentViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldDisplayNotification {
            deepLink.showWanderingKittyRecap = true
            shouldDisplayNotification = false
        }
    }
    
    func refreshCheck() -> Bool {
        let moc = container.viewContext
        let request: NSFetchRequest<WanderingKitty> = WanderingKitty.fetchRequest()
        do{
            return try moc.fetch(request).isEmpty
        } catch {
            return true
        }
    }
    init() {
        container = NSPersistentContainer(name: "Model")
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder not implmented")
    }

}
