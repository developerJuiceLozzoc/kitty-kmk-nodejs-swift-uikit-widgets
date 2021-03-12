//
//  StatsModel.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
//

import Foundation



class StatsModel {
    func loadPageOfCelebs(type: Int, offset: Int,amount: Int,completion: @escaping (Result<CelebResults,KMKNetworkError>)->Void){
        guard let url = URL(string: "\(SERVER_URL)/game?where=\(type)&offset=\(offset)&limit=\(amount)") else {completion(.failure(.invalidRequestError));return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request){ data,resp,err in
            guard let resp = resp as? HTTPURLResponse else {completion(.failure(.serverCreateError));return}
            guard resp.statusCode == 200 else {completion(.failure(.invalidClientRequest));return;}
            
            do{
                let stuff = try JSONDecoder().decode(CelebResults.self, from: data!)
                completion(.success(stuff))
            }
            catch let error {
                print(error)
                completion(.failure(.decodeFail))
            }
            
        }.resume()
        
    }
}
