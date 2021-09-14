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
        
        let listvc = UIStoryboard.init(name: "ListMyKitties", bundle: nil).instantiateViewController(identifier: "List_Kitties")
        listvc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        
        viewControllers = [listvc]
        selectedIndex = 0
    }
    

    

}
