//
//  MainTabController.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit
import SwiftUI


struct TabItemView: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    
    func makeUIViewController(context: Context) -> UIViewController { viewController }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the UIViewController if needed
    }
}

enum Tab: String {
    case porch, zipcode, collection
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .zipcode
    
    func unselectedImage(for tab: Tab) -> Image {
        switch tab {
        case .porch:
            return Image(systemName: "house")
        case .zipcode:
            return Image(systemName: "mappin.and.ellipse")
        case .collection:
            return Image(systemName: "person.crop.circle")
        }
    }
    
    private let neighborHoodViewModel: NeighborhoodScene.ViewModel = .init()

    var body: some View {
        TabView(selection: $selectedTab) {
            TabItemView(viewController: KittyPlagroundHostingController())
                .tabItem {
                    unselectedImage(for: .porch)
                }
                .tag(Tab.porch)
            
            NeighborhoodSceneView(viewModel: neighborHoodViewModel)
                .tabItem {
                    unselectedImage(for: .zipcode)
                }
                .tag(Tab.zipcode)
            
            
            // Add your tab views here
            TabItemView(viewController: ListKittiesHostingController())
               .tabItem {
                   unselectedImage(for: .collection)
               }
               .tag(Tab.collection)
        }
        .accentColor(Color("ultra-violet-1"))
    }
}

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // api request to fetch the toggles, and set that in static memory.
        
        
        tabBar.tintColor = UIColor.purple
        
        let listvc = ListKittiesHostingController()
        listvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        let playgroundvc = KittyPlagroundHostingController()
        playgroundvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "house"), selectedImage: UIImage(named: "house.circle.fill"))

        
        let neighborhoodvc = NeighborhoodSceneViewHostingController(rootView: NeighborhoodSceneView(viewModel: .init()))
        neighborhoodvc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: UIImage(systemName: "mappin.and.ellipse"))
        viewControllers = [playgroundvc, neighborhoodvc, listvc]
        selectedIndex = 1
    }
    

    

}
