//
//  Schema.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
//

import Foundation

struct KittyPlaygroundState: Equatable {
    var foodbowl: Int
    var waterbowl: Int
    var toys: [ToyItemUsed]
}

struct ZeusFeatureToggles: Codable {
    var instantPushKitty: Bool
}

struct WanderingKittyNotification {
    var KITTY_BREED: String
    var NOTIFICATION_ID: String
    
}

struct KittyApiResults: Codable {
    var breeds: [KittyBreed]
    var id: String
    var url: String
    
}
struct KittyBreed: Codable {
    init(id: String,name: String,temperament: String,description: String, life_span: String,dog_friendly: Int,
         energy_level: Int,
         shedding_level: Int,
         intelligence: Int,
         stranger_friendly: Int,
         origin: String, image: imgtype) {
        self.id = id
        self.name = name
        self.temperament = temperament
        self.description = description
        self.life_span = life_span
        self.dog_friendly = dog_friendly
        self.energy_level = energy_level
        self.shedding_level = shedding_level
        self.intelligence = intelligence
        self.stranger_friendly = stranger_friendly
        self.origin = origin
        self.image = image
    }
    
    init(fromRealm link: KStatsRealm) {
        self.id = link.breedid
        self.name = link.name
        self.description = link.kitty_description
        self.temperament = link.temperament
        self.life_span = link.life_span
        self.dog_friendly = link.dog_friendly
        self.energy_level = link.energy_level
        self.intelligence = link.intelligence
        self.shedding_level = link.shedding_level
        self.stranger_friendly = link.stranger_friendly
        self.origin = link.origin
    }

    var id: String
    var name: String
    var temperament: String
    var description: String
    var life_span: String
    var dog_friendly: Int
    var energy_level: Int
    var shedding_level: Int
    var intelligence: Int
    var stranger_friendly: Int
    var origin: String
    var image: imgtype?
    // var mageLvl: Int // just a made up stat because all these other stats might as well be fake too
    // var images: aggregate the entire array of kitties to retriev 50 urls and lazy load them
    
}
struct imgtype: Codable {
    var url: String?
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