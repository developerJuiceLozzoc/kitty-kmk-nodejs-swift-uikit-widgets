//
//  ZeusToggles.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/14/21.
//

import Foundation


class ZeusToggles {
    
    static let shared: ZeusToggles = ZeusToggles()
    var didLoad: Bool
    var toggles: ZeusFeatureToggles
    
    private init() {
        self.didLoad = false
        self.toggles = ZeusFeatureToggles(instantPushKitty: false)
    }
}
