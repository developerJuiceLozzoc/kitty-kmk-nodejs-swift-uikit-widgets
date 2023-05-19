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
    var subscription: String
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
struct KittyBreed: Codable, Hashable {
    static var previewsDummy: Self {
        .init(id: "", name: "", temperament: "", description: "", life_span: "", dog_friendly: 5, energy_level: 5, shedding_level: 5, intelligence: 5, stranger_friendly: 5, origin: "", image: .init())
    }
    static var previews: Self {
        .init(id: "abys", name: "Abyssinian",
              temperament: "Active, Energetic, Independent, Intelligent, Gentle",
              description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.", life_span: "14 - 15", dog_friendly: 1, energy_level: 5, shedding_level: 2, intelligence: 5, stranger_friendly: 5, origin: "Egypt", image: .init())
    }
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
    init(fromCoreData link: KStats?) {
        self.id = link?.breed_id ?? ""
        self.name = link?.name ?? ""
        self.description = link?.kitty_description ?? ""
        self.temperament = link?.temperament ?? ""
        self.life_span = link?.life_span ?? ""
        self.dog_friendly = Int(link?.dog_friendly ?? 0)
        self.energy_level = Int(link?.energy_level ?? 0)
        self.intelligence = Int(link?.intelligence ?? 0)
        self.shedding_level = Int(link?.shedding_level ?? 0)
        self.stranger_friendly = Int(link?.stranger_friendly ?? 0)
        self.origin = link?.origin ?? ""
        self.magic_level = Int(link?.magic_level ?? 0)
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
    var magic_level: Int? = 0    
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
