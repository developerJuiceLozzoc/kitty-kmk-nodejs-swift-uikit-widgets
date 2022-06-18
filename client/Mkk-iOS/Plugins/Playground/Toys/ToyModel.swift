//
//  ToyModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 6/18/22.
//

import Foundation


class ToyNetworkManager: ObservableObject {
    // handles errors on updating something
    @Published public var updateState: String?
    // handles erros on loading something
    @Published public var networkState = NetworkState.idle
    private var network: KittyJsoner = KittyJsoner()

    func retrieveCurrentState() {
        
    }
    func explicitClearNotification() {
        if let nid = KittyPlistManager.getNotificationToken()  {
            self.networkState = .loading
            self.network.deleteOldNotification(id: nid, with: "adopted") { [weak self] (result) in
                guard let self = self else {return}
                switch result {
                    case .success(_):
                    self.networkState = .success
                        KittyPlistManager.removeNotificationToken()
                        
                    default:
                        self.networkState = .failed
                         
                    }
            }
        }
    }
}
