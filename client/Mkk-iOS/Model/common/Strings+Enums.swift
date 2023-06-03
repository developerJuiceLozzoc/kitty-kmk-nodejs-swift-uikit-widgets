//
//  ActionTypes.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import Foundation

                /* action a     action b            action c*/
let VOTE_LIST = ["Adopt Kitty","Have Konversation", "Give Petz"]

let KITTY_BREEDS_URL = "https://api.thecatapi.com/v1/breeds/"
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

let possibleFontNames = "noteworty, papyrus, PARTY LET, Zapino"


let VOTE_CELL_REUSE:String = "This cell has a picture and a thick segmented control."
//let SERVER_URL = "https://kissmarrykill.herokuapp.com"
let SERVER_URL = "http://localhost:3000"
//let SERVER_URL = "http://10.1.10.76:3000"
//let SERVER_URL = "http://10.0.0.74:3000"
//let SERVER_URL = "http://10.0.0.79:3000"
//let SERVER_URL = "http://10.0.0.123:3000"

struct ToyItemUsed: Hashable {
    let dateAdded: Double
    let type: ToyType
    var timesInteracted = 0
    
    init (dateAdded: Double, type: ToyType, hits: Int){
        self.dateAdded = dateAdded
        self.type = type
        self.timesInteracted = hits
    }
    init(dictionary: NSDictionary) {
        if let dAdded = dictionary.object(forKey: "dateAdded") as? Double,
           let typeInt = dictionary.object(forKey: "type") as? Int,
           let hits = dictionary.object(forKey: "timesInteracted") as? Int {
            self.dateAdded = dAdded
            self.type = ToyType(rawValue: typeInt) ?? .unknown
            self.timesInteracted = hits
        } else {
            self.dateAdded = -1
            self.type = .unknown
            self.timesInteracted = -1
        }
    }
}

enum PouringState: Int {
    case idle = 0
    case transition
    case pouring
    case overflowing
}
enum PouringSpeedEnum: String {
    case notpouring = "Not Pouring"
    case steady = "Steady"
    case dumping = "Dumping that water"
}


/* TODO: Add more toys for more combinations
 */
enum ToyType: Int, CaseIterable, Decodable {
    case yarnball = 0
    case shinystring
    case chewytoy
    case scratchpost
    case unknown
    
    func toString() -> String {
        return ["Yarn Ball","Shiny String","Chewy Toy","Scratch Post", "Unknown"][self.rawValue]
    }
}

enum NetworkState: Int {
    case idle = 0
    case loading
    case failed
    case success
}

enum KMKAlertType: Int {
    case removeNotifSuccess = 0
    case removeNotifFailureBackground
    case removeNotifFailureForeground
    case failedRegisterForPush
    case succRegisterForPush
    case noneError
}


enum KMKNetworkError: String, Error {
    case noneError = "idle state"
    case decodeFail = "Failed to code the GameSurvey Struct"
    case urlError = "Failed to create a url"
    case serverSaveError = "Server failed to respond to SaveSurvey"
    case serverCreateError = "Server failed to return new game survey"
    case invalidRequestError = "the object was not the format as expected"
    case noImageFoundError = " the requested image was not availible"
    case noBreedsFoundError = "no breed images found wiht requested idv"
    case invalidClientRequest = "the server responded with errror"
    case respNotHTTP = "could not convert response object."
    case noDocumentSuccess = ""
    case notificationServerError = "Sorry, we had problems looking up your opt in registraction status."
    case deviceNotRegistered = "This device does not contain a notification token claiming authorization."
    case serverGateway = "The request with the server gateway failed"
    case notFound = "the page you requested could not be found."
    case clientRejectedRequest = "The client has rejected our request"
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

public enum OSEnvironment {
    case mac, iphone, simulator
}

func kmk_readOsType() -> OSEnvironment? {
    /*
  path to the "Documents" folder on iOS:
    "/var/mobile/Containers/Data/Application/8C2D631A-DCBB-44FE-8F86-429A89FCE921/Documents" -> iOS

  path to the "Documents" folder on macOS:
    "/Users/USER_NAME/Library/Containers/4EE76C41-2BE8-4A65-B26C-080773E0EB31/Data/Documents"  -> Mac
     
     
     simulator /Users/USER/Library/Developer/CoreSimulator/Devices/C065C350-8DC0-4CA5-AF63-A19D998B41DF/data/Containers/Data/Application/5A45A272-AD16-4F1C-939F-BCED22E4A7B4/Documents
     
     macos
     n /Users/USER/Library/Containers/43B15322-8173-4D40-BE9A-D7539EFC41A7/Data/Documents"
    */
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    guard let documentsDirectory = paths.first else {
        return nil
    }
    let isMacAppleSilicon = documentsDirectory.hasPrefix("/Library/Containers")
    let isSimulator = documentsDirectory.hasPrefix("/CoreSimulator")
    let isNative = documentsDirectory.hasPrefix("/var/mobile")
    
    if !isSimulator && !isMacAppleSilicon && !isMacAppleSilicon {
        return nil
    }
    
    if isMacAppleSilicon {
        return .mac
    } else if isSimulator {
        return .simulator
    } else if isNative {
        return .iphone
    }


    return nil
}
