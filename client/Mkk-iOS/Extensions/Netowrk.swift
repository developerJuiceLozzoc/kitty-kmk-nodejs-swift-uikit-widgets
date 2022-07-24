//
//  Netowrk.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/3/21.
//

import UIKit

struct SimpleId: Decodable {
    var id: String
}

class KittyJsoner: CatApier {
    func dispatchNotificationsImmediately(completion: @escaping (Result<Void, KMKNetworkError>) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/notifications/dispatch") else {
            completion(.failure(.urlError)); return;
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request){data,response,err in
            if let resp = response as? HTTPURLResponse {
                switch(resp.statusCode){
                case 200:
                    completion(.success(Void()))
                case 400:
                    completion(.failure(.invalidClientRequest))
                default:
                    completion(.failure(.serverCreateError))
                }
            }
            else{
                completion(.failure(.decodeFail))
            }
        }.resume()
    }
    
    func retreiveDocumentTokenForScheduledPushIfExists(completion: @escaping (Result<String, KMKNetworkError>) -> Void) {
        guard let token = KittyPlistManager.getFirebaseCloudMessagagingToken(),
        let did = UIDevice.current.identifierForVendor?.uuidString
        else { completion(.failure(.deviceNotRegistered));return; }
        
        guard let url = URL(string: "\(SERVER_URL)/notifications/subscription?deviceid=\(did)&breed=any&fireToken=\(token)") else {
            completion(.failure(.urlError)); return;
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){data,response,err in
            if let resp = response as? HTTPURLResponse {
                switch(resp.statusCode){
                case 200:
                    guard let data = data,
                          let decoded = try? JSONDecoder().decode(SimpleId.self, from: data)
                    else {
                        completion(.failure(.decodeFail))
                        return
                    }
                    completion(.success(decoded.id))
                case 400:
                    completion(.failure(.invalidClientRequest))
                default:
                    completion(.failure(.serverCreateError))
                }
            }
            else{
                completion(.failure(.decodeFail))
            }
        }.resume()
    }
    
    
    
    func fetchRemoteFeatureToggles(completion: @escaping (Result<ZeusFeatureToggles, KMKNetworkError>) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/ZeusToggles") else {
            completion(.failure(.urlError)); return;
        }
        URLSession.shared.dataTask(with: url){data,response,err in
            if let resp = response as? HTTPURLResponse {
                switch(resp.statusCode){
                case 200:
                    do {
                        let toggles = try JSONDecoder().decode(ZeusFeatureToggles.self, from: data!)
                        completion(.success(toggles))
                    }
                    catch let err {
                        print(err)
                        completion(.failure(.decodeFail))
                    }
                case 400:
                    completion(.failure(.invalidClientRequest))
                default:
                    completion(.failure(.serverCreateError))
                }
            }
            else{
                completion(.failure(.decodeFail))
            }
        }.resume()
    }
    
    func getKittyImageByBreed(with breed: String, completion: @escaping (Result<UIImage, KMKNetworkError>) -> Void) {
        completion(.success(UIImage(systemName: "hare.fill")!))
    }
    
    func getJsonByBreed(with breed: String, completion: @escaping (Result<[KittyApiResults], KMKNetworkError>) -> Void) {
        guard let url = URL(string: "\(KITTY_URL)&breed_ids=\(breed)") else {
            completion(.failure(.urlError)); return;
        }
        URLSession.shared.dataTask(with: url){data,resp,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
                if let data = data {
                    do{
                        let swiftkitty = try JSONDecoder().decode([KittyApiResults].self, from: data)
                        completion(.success(swiftkitty))
                    }
                    catch let err{
                        print(err)
                        completion(.failure(.decodeFail))
                    }

                }else{
                    completion(.failure(.noBreedsFoundError))
                    
                }
        }.resume()
        
    }
    private func registerForNotifications(completion: @escaping (Result<Void,KMKNetworkError>) -> Void) {
        
        
        let semaphore = DispatchSemaphore(value: 1)

    }
    
    func postNewNotification(completion: @escaping (Result<String,KMKNetworkError>)->Void){
        guard let selected_breed = KITTY_BREEDS.randomElement() else { completion(.failure(.noBreedsFoundError));return;}
        guard let token = KittyPlistManager.getFirebaseCloudMessagagingToken(),
        let did = UIDevice.current.identifierForVendor?.uuidString
        else { completion(.failure(.deviceNotRegistered));return; }
        guard let url = URL(string: "\(SERVER_URL)/notifications/schedule?deviceid=\(did)&breed=any&fireToken=\(token)") else {
            completion(.failure(.urlError))
            return
        }
        let semaphore = DispatchSemaphore(value: 1)
        var registrationError: Error?
        semaphore.wait()
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions){ authorized, error in
                defer {
                    semaphore.signal()
                }
                if !authorized {
                    registrationError = NSError(domain: "Authorization denied", code: 500)
                }
                if error != nil {
                    registrationError = error
                }
            }
        
        semaphore.wait()
        if let error = registrationError {
            print(String.init(describing: error))
            completion(.failure(.deviceNotRegistered))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request){data,response,err in
            defer {
                semaphore.signal()
            }
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
            if let resp = response as? HTTPURLResponse {
                switch(resp.statusCode){
                case 201:
                    guard let data = data,
                          let decoded = try? JSONDecoder().decode(SimpleId.self, from: data)
                    else {
                        completion(.failure(.decodeFail))
                        return
                    }
                    completion(.success(decoded.id))
                case 400:
                    completion(.failure(.invalidClientRequest))
                default:
                    completion(.failure(.serverCreateError))
                }
            }
            else{
                completion(.failure(.decodeFail))
            }
        }.resume()
        
        print("selected breed", selected_breed)
        
    }
    
    func getKittyImageByBreed(with breed: String) {
        return 
    }
    
    func discontinueCurrentNotificationSubscription(documentID: String, completion: @escaping (Result<Void,KMKNetworkError>) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/notification/\(documentID)") else {
            completion(.failure(.urlError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request){data,response,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
            if let resp = response as? HTTPURLResponse {
                if(resp.statusCode != 200){
                    completion(.failure(.noImageFoundError))
                }
                else{
                    completion(.success(Void()))
                }
            }
            else{
                completion(.failure(.respNotHTTP))
            }
        }.resume()
    }
    
    func deleteOldNotification(id: String, with status: String, completion: @escaping (Result<Bool,KMKNetworkError>)->Void){
        guard let url = URL(string: "\(SERVER_URL)/notifications?adoption_status=\(status)&notification_id=\(id)") else {
            completion(.failure(.urlError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request){data,response,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
            if let resp = response as? HTTPURLResponse {
                switch resp.statusCode {
                case 200:
                    completion(.success(true))
                    break
                case 404:
                    completion(.failure(.noDocumentSuccess))
                default:
                    completion(.failure(.notificationServerError))
                }
            }
            else{
                completion(.failure(.decodeFail))
            }
        }.resume()
    }
    
    
}



class ImageLoader: Loader {
    func load(url: URL, completion: @escaping (Result<UIImage,KMKNetworkError>) -> Void){
        URLSession.shared.dataTask(with: url){data,resp,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
                if let data = data {
                    guard let img = UIImage(data: data) else {completion(.failure(.noImageFoundError));return;}
                    completion(.success(img))

                }else{
                    completion(.failure(.noImageFoundError))
                    
                }
        }.resume()
    }
}
