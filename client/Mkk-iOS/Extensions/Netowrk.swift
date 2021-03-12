//
//  Netowrk.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/3/21.
//

import UIKit

//protocol KMKApi {
//    func fetch
//}
//
//class NetworkManager: KMKApi {
//
//}

enum KMKNetworkError: String,Error{
    case decodeFail = "Failed to code the GameSurvey Struct"
    case urlError = "Failed to create a url"
    case serverSaveError = "Server failed to respond to SaveSurvey"
    case serverCreateError = "Server failed to return new game survey"
    case invalidRequestError = "the object was not the format as expected"
    case noImageFoundError = " the requested image was not availible"
    case invalidClientRequest = "the server responded with errror"
}

protocol Loader {
    func load(url: URL, completion: @escaping (Result<UIImage,KMKNetworkError>) -> Void)
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
