//
//  KMKExtensions.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/30/23.
//

import Foundation

//public extension View {
//
//}


public func kmk_isPreviews() -> Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
