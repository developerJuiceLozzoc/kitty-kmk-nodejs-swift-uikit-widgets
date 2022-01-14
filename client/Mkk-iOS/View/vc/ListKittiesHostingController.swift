//
//  ListKittiesHostingController.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/13/22.
//

import UIKit
import SwiftUI

struct ListKittiesWrapper: View {
    @State var shouldShowTutorial: Bool = false
    var body: some View {
        NavigationView<ListKittiesView> {
            ListKittiesView()
        }.toolbar {
            Image("questionmark.circle")
                .resizable()
                
                .frame(width: 30, height: 30)
                .padding()
                .onTapGesture {
                    shouldShowTutorial.toggle()
                }
        }
        .popover(isPresented: $shouldShowTutorial, content: {
            if #available(iOS 15.0, *) {
                ListTutorialPopup()
                    .textSelection(.enabled)
                    .onDisappear {
                        ZeusToggles.shared.setHasReadListTutorial()
                    }
            } else {
                ListTutorialPopup()
                    .onDisappear {
                        ZeusToggles.shared.setHasReadListTutorial()
                    }
            }
        })
    }
}

class ListKittiesHostingController: UIViewController {

    var contentView: ListKittiesWrapper! /*{
        didSet {
            guard let contentView = self.contentView else {
                return
            }
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView = ListKittiesWrapper()
        let contentViewController = UIHostingController(rootView: self.contentView )
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}
