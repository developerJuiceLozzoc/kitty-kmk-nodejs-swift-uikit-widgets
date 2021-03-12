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
        tabBar.tintColor = UIColor.purple
        
        let collectionvc = UIStoryboard.init(name: "StatsExperience", bundle: nil).instantiateViewController(identifier: "collectionviewc")
        collectionvc.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        let gamevc = UIStoryboard.init(name: "Game", bundle: nil).instantiateViewController(identifier: "maingame")
        gamevc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        viewControllers = [gamevc,collectionvc]
        
        selectedIndex = 1
    }
    

    

}
