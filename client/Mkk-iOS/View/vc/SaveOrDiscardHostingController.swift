//
//  SaveOrDiscardHostingController.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import UIKit
import SwiftUI

class KittyPFPViewModel: ObservableObject {
    @Published var datas: [Data] = []
    
    func loadUrls(with urls: [String]) {
        urls.forEach { str in
            guard let url = URL(string: str) else {return}
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.datas.append(data)
                }

            }
            task.resume()
        }
    }
}

class SaveOrDiscardHostingController: UIViewController {
    var network = KittyJsoner()
    var notification: WanderingKittyNotification!
    var adoptionStatus: String = "false"
    var rlm = RealmCrud()
    let vm:KittyPFPViewModel = KittyPFPViewModel()
    
    var kitty: [KittyApiResults]? {
        didSet {
            guard let kitties = self.kitty, let kitty = self.kitty?.first?.breeds.first else {return}
            var urls: [String] = []
            let count: Int = kitties.count > 8 ? 8 : kitties.count
            for n in 0..<count {
                urls.append(kitties[n].url)
            }
            vm.loadUrls(with: urls)
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
    }

}

extension SaveOrDiscardHostingController: ConfirmKittyable {
    func confirmAdoption() {

        adoptionStatus = "true"
        navigationController?.popViewController(animated: true)
        
    }
    
    
}
