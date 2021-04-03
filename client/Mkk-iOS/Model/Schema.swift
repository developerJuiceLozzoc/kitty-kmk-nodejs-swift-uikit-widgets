//
//  Schema.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
//

import Foundation

struct KittyApiResults: Codable {
    var breeds: [KittyBreed]
    var id: String
    var url: String
    
}
struct KittyBreed: Codable {

    var id: String
    var name: String
    var temperament: String
    var description: String
    var life_span: String
    var dog_friendly: Int16
    var energy_level: Int16
    var shedding_level: Int16
    var stranger_friendly: Int16
    var origin: String
    
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

struct MongoCollectionSurvey: Codable {
    var _id: String
    var imgurls: [String]
    var actions: [String]
}
struct CelebResults: Codable {
    var surveys: [MongoGameSurvey]
    var dict: [String: String]
}
