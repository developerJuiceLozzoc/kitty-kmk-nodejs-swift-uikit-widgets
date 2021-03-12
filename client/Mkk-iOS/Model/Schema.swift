//
//  Schema.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
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

struct MongoGameSurvey: Codable {
    var _id: String
    var celebs: [String]
    var actiona: String
    var actionb: String
    var actionc: String
}

struct MongoCollectionSurvey: Codable {
    var _id: String
    var imgurls: [String]
    var actions: [String]
}
struct CelebResults: Codable {
    var surveys: [MongoGameSurvey]
    var dict: [String: String]
}
