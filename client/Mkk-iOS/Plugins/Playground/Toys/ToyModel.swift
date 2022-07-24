//
//  ToyModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 6/18/22.
//

import Foundation
import Firebase

class ToyNetworkManager: ObservableObject {
    // handles errors on updating something
    @Published public var updateState: String?
    // handles erros on loading something
    @Published public var networkState = NetworkState.idle
    private var network: KittyJsoner = KittyJsoner()

    func retrieveCurrentState() {
//        network.postNewNotification(withDeviceName: DEVICE_ID, completion: <#T##(Result<Bool, KMKNetworkError>) -> Void#>)
    }
    func explicitClearNotification(completion: @escaping (Result<Bool, KMKNetworkError>) -> ()) {
        if let nid = KittyPlistManager.getNotificationToken()  {
            DispatchQueue.main.async {
                self.networkState = .loading
            }
            self.network.deleteOldNotification(id: nid, with: "unsubscribed") { [weak self] (result) in
                guard let self = self else {return}
                DispatchQueue.main.async { [ weak self] in
                    guard let self = self else {return}
                    switch result {
                        case .success(_):
                        self.networkState = .success
                            KittyPlistManager.removeNotificationToken()
                            
                        default:
                            self.networkState = .failed
                             
                        }
                }
                
                completion(result)
            }
        }
    }
    private func registerForNotifications(completion: @escaping (Result<Void,KMKNetworkError>) -> Void) {

        let dg = DispatchGroup()
        var registrationError: Error?
        dg.notify(queue: .main) {
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            dg.enter()
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions){ authorized, error in
                    defer {
                        dg.leave()
                    }
                    if !authorized {
                        registrationError = NSError(domain: "Authorization denied", code: 500)
                    }
                    if error != nil {
                        registrationError = error
                    }
                }
        }
        
        dg.notify(queue: .main) {
            if let error = registrationError {
                print(String.init(describing: error))
                completion(.failure(.deviceNotRegistered))
            } else {
                completion(.success(()))
            }
        }
        
    }
    
    func tryDeleteNotification(mainThreadCompletion: @escaping(Result<Bool,KMKNetworkError>)->Void) {
        // delete it from scheduler in cloud, keep device consent on. request authorization again if needed.
        guard let nid = KittyPlistManager.getNotificationToken() else {
            mainThreadCompletion(.failure(.deviceNotRegistered))
            return}
        network.deleteOldNotification(id: nid, with: "adopted") { (result) in
            // maybe the item is no longer there since i often rinse the entire collection lmao.
            DispatchQueue.main.async {
                mainThreadCompletion(result)
            }
        }
        
    }
}
