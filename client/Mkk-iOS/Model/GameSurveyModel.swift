//
//  GameSurveyModel.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/12/21.
//

import Foundation


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





let dummySurvey =
    GameSurvey(_id: "hehehaha",
                 celebs: [
                    Celebrity(name: "705/1334",
                              imgurl: "https://placekitten.com/705/1334",
                              _id: "6026fe49ff0963228a81bbc8"),
                    Celebrity(name: "25x1000", imgurl: "https://placekitten.com/706/1334", _id: "6026fe49ff0963228a81bbc8"),
                    Celebrity(name: "75x200", imgurl: "https://placekitten.com/707/1334", _id: "6026fe4aff0963228a81bbc9")
                ])
class GameSurveyModel {
    static func fetchNewGame(completion: @escaping (GameSurvey?)->Void){
        completion(dummySurvey)
    }
}
