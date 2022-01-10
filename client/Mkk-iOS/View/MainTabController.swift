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
        listvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        let playgroundvc = KittyPlagroundHostingController()
        playgroundvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "house"), selectedImage: UIImage(named: "house.circle.fill"))
        
        viewControllers = [playgroundvc,listvc]
        selectedIndex = 1
    }
    

    

}
