//
//  Netowrk.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/3/21.
//

import UIKit

class KittyJsoner: CatApier {
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
    func postNewNotification(withDeviceName name: String, completion: @escaping (Result<Bool,KMKNetworkError>)->Void){
        guard let selected_breed = KITTY_BREEDS.randomElement() else { completion(.failure(.noBreedsFoundError));return;}
        
        
        guard let url = URL(string: "\(SERVER_URL)/notifications/schedule?deviceid=\(name)&breed=\(selected_breed)") else {
            completion(.failure(.urlError))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request){data,response,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
            if let resp = response as? HTTPURLResponse {
                switch(resp.statusCode){
                case 201:
                    completion(.success(true))
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
    
    func getKittyImageByBreed(with breed: String) {
        return 
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
                if(resp.statusCode != 201){
                    completion(.failure(.serverCreateError))
                }
                else{
                    completion(.success(true))
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
