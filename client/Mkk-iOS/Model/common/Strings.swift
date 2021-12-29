//
//  ActionTypes.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import Foundation

                /* action a     action b            action c*/
let VOTE_LIST = ["Adopt Kitty","Have Konversation", "Give Petz"]

let KITTY_URL = "https://api.thecatapi.com/v1/images/search?limit=50"

let KITTY_BREEDS: [String]  = [
    "abys", "aege", "abob", "acur", "asho", "awir",
    "amau", "amis", "bali", "bamb", "beng", "birm",
    "bomb", "bslo", "bsho", "bure", "buri", "cspa",
    "ctif", "char", "chau", "chee", "csho", "crex",
    "cymr", "cypr", "drex", "dons", "lihu", "emau",
    "ebur", "esho", "hbro", "hima", "jbob", "java",
    "khao", "kora", "kuri", "lape", "mcoo", "mala",
    "manx", "munc", "nebe", "norw", "ocic", "orie",
    
    "pers", "pixi", "raga", "ragd", "rblu", "sava",
    "sfol", "srex", "siam", "sibe", "singsstrub", "snow",
    "soma", "sphy", "tonk", "toyg", "tang", "tvan",
    "ycho"
  ]

let MOCK_NAMES: [String] = [
    "Edith Benson" ,   "Kenley Charlton",
    "Queena Webley",    "Lee Morton",
    "Heather Kimberly",    "Nelson Lindsey",
    "Aspen Addington",    "Doyle Rodney",
    "Ena Kendal",    "Athelstan Chatham"
    ]


let VOTE_CELL_REUSE:String = "This cell has a picture and a thick segmented control."
let SERVER_URL = "https://kissmarrykill.herokuapp.com"
//let SERVER_URL = "http://localhost:3000"
//let SERVER_URL = "http://10.1.10.76:3000"
//let SERVER_URL = "http://10.0.0.74:3000"

struct ToyItemUsed {
    let dateAdded: Double
    let type: ToyType
    
    init (dateAdded: Double, type: ToyType){
        self.dateAdded = dateAdded
        self.type = type
    }
    init(dictionary: NSDictionary) {
        if let dAdded = Double(dictionary["dateAdded"] as? String ?? "-1"),
           let typeInt = Int(dictionary["type"] as? String ?? "-1") {
            self.dateAdded = dAdded
            self.type = ToyType(rawValue: typeInt) ?? .unknown
        } else {
            self.dateAdded = -1
            self.type = .unknown
        }
    }
}

enum ToyType: Int {
    case yarnball = 0
    case shinystring
    case stuffedtoy
    case chewytoy
    case scratchpost
    case unknown
}


enum KMKNetworkError: String,Error{
    case decodeFail = "Failed to code the GameSurvey Struct"
    case urlError = "Failed to create a url"
    case serverSaveError = "Server failed to respond to SaveSurvey"
    case serverCreateError = "Server failed to return new game survey"
    case invalidRequestError = "the object was not the format as expected"
    case noImageFoundError = " the requested image was not availible"
    case noBreedsFoundError = "no breed images found wiht requested idv"
    case invalidClientRequest = "the server responded with errror"
}

enum ActionCellGestureType: String {
    case scrub = "swipe(scrub) right to left repeatedly" // Drag 
    case pour = "with two fingers, slowly pull from top to bottom, careful not to overpour"
    case tap = "one finger tap"
}

extension Notification.Name {
    static let voteDidChange = Notification.Name("Pressed this Button with Value x on Entity y")
    static let gamesurveyDidLoad = Notification.Name("Finished loading new survey from API")
    static let radiobttnUpdate = Notification.Name("Assign this button this state")
}
