//
//  KittieDetailsSwiftUI.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import UIKit
import SwiftUI

class KittieDetailsSwiftUI: UIViewController {
    var details: KittyRealm?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let kitty = self.details, let statsLink = kitty.statsLink, let imgLink = kitty.photoLink?.img else {return}
        let breed = KittyBreed(fromRealm: statsLink)
        let contentView = UIHostingController(rootView: KittyDetailsView(stats: breed, pfp: UIImage(data: imgLink) ?? UIImage(), name: kitty.name, birthday: kitty.birthday))
        
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }

}
