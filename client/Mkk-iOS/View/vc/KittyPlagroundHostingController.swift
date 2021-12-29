//
//  KittyPlagroundHostingController.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/28/21.
//

import UIKit
import SwiftUI

struct KittyPlaygroundState {
    var foodbowl: Int
    var waterbowl: Int
    var toys: [ToyItemUsed]
}


class KittyPlagroundHostingController: UIViewController {

    var contentView: KittyActionButtonContainer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView = KittyActionButtonContainer()
        let contentViewController = UIHostingController(rootView: self.contentView )
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
//    init() {
//
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }

}
