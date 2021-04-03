//
//  Netowrk.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/3/21.
//

import UIKit

class KittyJsoner: CatApier {
    func getJsonByBreed(with breed: String, completion: @escaping (Result<KittyBreed, KMKNetworkError>) -> Void) {
        guard let url = URL(string: <#T##String#>)
    }
    
    func getKittyImageByBreed(with breed: String) {
        return 
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
