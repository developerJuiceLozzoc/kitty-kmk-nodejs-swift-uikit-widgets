//
//  ActionTypes.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import Foundation
import UIKit

let VOTE_LIST = ["Action A","Action B", "Action C"]



let VOTE_CELL_REUSE:String = "This cell has a picture and a thick segmented control."
let SERVER_URL = "https://kissmarrykill.herokuapp.com"
//let SERVER_URL = "http://localhost:3000"


extension Notification.Name {
    static let voteDidChange = Notification.Name("Pressed this Button with Value x on Entity y")
    static let gamesurveyDidLoad = Notification.Name("Finished loading new survey from API")
    static let radiobttnUpdate = Notification.Name("Assign this button this state")
}

