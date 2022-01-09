//
//  NotificationObjects.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import Foundation


class VoteIdentity: NSObject {
    var entity: Int
    var value: Int
    init(entity: Int,value: Int){
        self.entity = entity
        self.value = value
    }
    static func == (lhs: VoteIdentity, rhs: VoteIdentity) -> Bool{
        return lhs.entity == rhs.entity 
    }
}

class SwapRadioButtons: NSObject {
    var e1: VoteIdentity
    var e2: VoteIdentity
    init(swap e1: VoteIdentity, with e2: VoteIdentity){
        self.e1 = e1
        self.e2 = e2
    }
}



