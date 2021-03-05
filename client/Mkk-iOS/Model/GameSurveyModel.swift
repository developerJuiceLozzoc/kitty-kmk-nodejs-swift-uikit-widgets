//
//  GameSurveyModel.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/12/21.
//

import Foundation

protocol KMKApi {
    func fetchNewGame(completion: @escaping (Result<GameSurvey,KMKNetworkError>)->Void)
    // after submitting one, we expect to complete another.
    func submitGameResult(with survey: GameSurvey, completion: @escaping (Result<GameSurvey,KMKNetworkError>) -> Void)

}


struct Celebrity: Codable {
    var name: String
    var imgurl: String
    var _id: String
}
struct GameSurvey: Codable {
    var votes: [Int] = [0,1,2] // references the celebrity array
    var _id: String
    var celebs: [Celebrity]

}

struct MongoGameSurvey: Codable {
    var _id: String
    var celebs: [String]
    var actiona: String
    var actionb: String
    var actionc: String
}



class GameSurveyModel: KMKApi {
    
    func serializeGameSurvey(with survey: GameSurvey) throws -> Data {
        var mongosurveydoc = MongoGameSurvey(_id: survey._id, celebs: survey.celebs.map({ $0._id }), actiona: "", actionb: "", actionc: "")
        mongosurveydoc.actiona = survey.celebs[survey.votes[0]]._id
        mongosurveydoc.actionb = survey.celebs[survey.votes[1]]._id
        mongosurveydoc.actionc = survey.celebs[survey.votes[2]]._id
        return try JSONEncoder().encode(mongosurveydoc)
    }
    
    func fetchNewGame(completion: @escaping (Result<GameSurvey, KMKNetworkError>) -> Void) {
        guard let url = URL(string: "\(SERVER_URL)/game/new") else { completion(.failure(.urlError)); return;}
        URLSession.shared.dataTask(with: URLRequest(url: url)){data,resp,err in
            guard let resp = resp as? HTTPURLResponse else {completion(.failure(.serverCreateError));return}
            guard resp.statusCode == 201 else {completion(.failure(.invalidRequestError));return;}
            do{
                let survey = try JSONDecoder().decode(GameSurvey.self, from: data!)
                completion(.success(survey))
            }
            catch let error {
                print(error)
                completion(.failure(.decodeFail))
            }
        }.resume()
    }
    
    func submitGameResult(with survey: GameSurvey, completion: @escaping(Result<GameSurvey,KMKNetworkError>) -> Void){
        guard let url = URL(string: "\(SERVER_URL)/game/\(survey._id)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let data = try serializeGameSurvey(with: survey)
            request.httpBody = data
        }
        catch {
            completion(.failure(.decodeFail))
            return
        }

        URLSession.shared.dataTask(with: request){data,resp,err in
            guard let resp = resp as? HTTPURLResponse else {completion(.failure(.serverCreateError));return}
            guard resp.statusCode == 200 else {completion(.failure(.invalidRequestError));return;}
            self.fetchNewGame { (result) in
                switch result {
                case .success(let survey):
                    completion(.success(survey))
                    break;
                case .failure(let err):
                    print(err)
                    completion(.failure(err))
                    break
                }
            }
            
            
        }.resume()
        
    }

}
