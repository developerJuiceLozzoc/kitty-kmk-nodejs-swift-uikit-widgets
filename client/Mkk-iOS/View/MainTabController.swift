//
//  MainTabController.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // api request to fetch the toggles, and set that in static memory.
        
        
        tabBar.tintColor = UIColor.purple
        
        let listvc = UIStoryboard.init(name: "ListMyKitties", bundle: nil).instantiateViewController(identifier: "List_Kitties")
        listvc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        let playgroundvc = KittyPlagroundHostingController()
        playgroundvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "leaf.circle"), selectedImage: UIImage(systemName: "leaf.circle.fill"))
        
        viewControllers = [playgroundvc,listvc]
        selectedIndex = 1
    }
    

    

}
