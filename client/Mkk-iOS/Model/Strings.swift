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
    "sfol", "srex", "siam", "sibe", "sing", "snow",
    "soma", "sphy", "tonk", "toyg", "tang", "tvan",
    "ycho"
  ]


let VOTE_CELL_REUSE:String = "This cell has a picture and a thick segmented control."
let SERVER_URL = "https://kissmarrykill.herokuapp.com"
//let SERVER_URL = "http://localhost:3000"



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

extension Notification.Name {
    static let voteDidChange = Notification.Name("Pressed this Button with Value x on Entity y")
    static let gamesurveyDidLoad = Notification.Name("Finished loading new survey from API")
    static let radiobttnUpdate = Notification.Name("Assign this button this state")
}
