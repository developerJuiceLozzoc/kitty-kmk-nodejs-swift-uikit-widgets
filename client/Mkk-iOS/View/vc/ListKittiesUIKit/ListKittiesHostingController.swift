//
//  ListKittiesSwiftUI.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/20/21.
//

import UIKit
import RealmSwift
import SwiftUI

class ListKittiesDataSource: ObservableObject {
    @Published var contentDataSource: [[KittyListRow]] = []
    @Published var sectionTitleDataSource: [String] = []
    
    init() {
        
    }
    
    init(content: [[KittyListRow]], sections: [String]) {
        sectionTitleDataSource = sections
        contentDataSource = content
    }
    
    @available(iOS 15.0.0, *)
    func loadStats() async -> Void {}
}

class ListKittiesSwiftUI: UIViewController {
    
    var cd = CoreData()
    var rlm = RealmCrud()
    var kitties: Results<KittyRealm>? {
        didSet {
            guard let kitties = self.kitties else {return}
            guard kitties.count > 0 else {return}
            self.parseDataSource()
        }
    }
    
    var ds: ListKittiesDataSource = ListKittiesDataSource()
    
    private func parseDataSource(){
        
        ds.contentDataSource = []
        ds.sectionTitleDataSource = []
        
        var breeddict: [String : [KittyListRow]] = [:]
        for kitty in self.kitties!{
            if let breedname = kitty.statsLink?.name {
                if  breeddict[breedname] == nil {
                    breeddict[breedname] = []
                }
                breeddict[breedname]!.append((name: kitty.name, id: kitty.uid))
            }
            
        }
        
        breeddict.keys.forEach { (breedname) in
            ds.sectionTitleDataSource.append(breedname)
            ds.contentDataSource.append(breeddict[breedname]!)
        }
    }
    
    override func viewDidLoad() {
        self.kitties = rlm.fetchKitties()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ds.contentDataSource = []
        ds.sectionTitleDataSource = []
        self.kitties = rlm.fetchKitties()
        
        for child in self.children {
            child.removeFromParent()
        }
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        setupConstraints()
        
    }
    
    
    private func setupConstraints() {
        let contentView = UIHostingController(rootView: ListKittiesView( onKittyClick: { [weak self] id in
            guard let self = self else {return}
            self.kittyKlicked(with: id)
        })
            .environmentObject(ds))
        
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }

    func kittyKlicked(with id: String) {
        guard let kitty = self.kitties?.first(where: { (k) -> Bool in
            return (k.uid == id)
        }) else{ return}
        
        performSegue(withIdentifier: "DetailsKitty", sender: kitty)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "ConfirmKitty":
                guard let vc = segue.destination as? SaveOrDiscardHostingController, let ks = sender as? [KittyApiResults] else {return}
                vc.kitty = ks
            case "DetailsKitty":
                guard let vc = segue.destination as? KittieDetailsSwiftUI, let details = sender as? KittyRealm else {return}
                vc.details = details
            case "ScheduleKitty":
                break;
            default:
                break;
        }
        
    }
    
}
