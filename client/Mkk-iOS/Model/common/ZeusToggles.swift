//
//  ZeusToggles.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/14/21.
//

import Foundation


class ZeusToggles {
    static var shared: ZeusToggles = ZeusToggles()
    var didLoad: Bool = false
    var toggles: ZeusFeatureToggles = ZeusFeatureToggles(instantPushKitty: false)
}
