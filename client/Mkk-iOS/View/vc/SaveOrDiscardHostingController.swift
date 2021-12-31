//
//  SaveOrDiscardHostingController.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import UIKit
import SwiftUI

class KittyPFPViewModel: ObservableObject {
    @Published var datas: [Data?] = []
    var imgurls: [String]
    
    init(count: Int, urls: [String]){
        self.imgurls = urls
        self.datas = Array.init(repeating: nil, count: count)
    }
    func loadImage(for index: Int) -> Data? {
        if let item = self.datas[index] {
            return item
        }
        let imageurl = self.imgurls[index]
        DispatchQueue.global().async {
            guard let url = URL(string: imageurl) else {return}
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {return}
                DispatchQueue.main.async { [weak self] in
                    guard let wself = self else { return }
//                    ?? UIImage(named: "image-not-found")?.pngData()
                    wself.datas[index] = data
                }

            }
            task.resume()
        }
        return nil
    }
}

class SaveOrDiscardHostingController: UIViewController {
    var network = KittyJsoner()
    var notification: WanderingKittyNotification!
    var adoptionStatus: String = "false"
    var rlm = RealmCrud()
    var vm: KittyPFPViewModel!
    
    var kitty: [KittyApiResults]? {
        didSet {
            guard let kitties = self.kitty, let kitty = self.kitty?.first?.breeds.first else {return}
            let urls: [String] = kitties.map { kitty  in
                return kitty.url
            }
            
            vm = KittyPFPViewModel(count: urls.count, urls: urls)
            self.createContentView(with: kitty)
        }
    }
    
    private func createContentView(with kat: KittyBreed){
        
        let v = ConfirmOrDiscardView(stats: kat, onAdoptionClick: { name,stats, data in
            DispatchQueue.main.async {
                self.rlm.addTodooeyToRealm(name: name, stats: stats, imgurl: "", imgdata: data)
                self.confirmAdoption()
            }
            
        }).environmentObject(vm)
                                      
        let contentView = UIHostingController(rootView: v )
        
        addChild(contentView)
        view.addSubview(contentView.view)
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        network.deleteOldNotification(id: notification.NOTIFICATION_ID, with: self.adoptionStatus) { (result) in
            switch result {
            case .success( _):
                break;
            case .failure(let e):
                print(e)
            }
        }
        guard let count = kitty?.count, count > 0 else {return}
        self.vm.datas = Array.init(repeating: nil, count: count)
        
        view.subviews.forEach { v in
            v.removeFromSuperview()
        }
        children.forEach { vc in
            vc.removeFromParent()
        }
        
        
    }

}

extension SaveOrDiscardHostingController: ConfirmKittyable {
    func confirmAdoption() {

        adoptionStatus = "true"
        navigationController?.popViewController(animated: true)
        
    }
    
    
}
