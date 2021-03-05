//
//  KMKFonts.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/22/21.
//

import Foundation
import UIKit


extension UIFont {
    static func kmkMain() -> UIFont {
        guard let font = UIFont(name: "Noteworthy",size: CGFloat(22)) else {return UIFont.preferredFont(forTextStyle: .body)}
        return font
    }
    static func kmkConfirmation() -> UIFont {
        guard let font = UIFont(name: "American Typewriter", size:(CGFloat(22))) else {return UIFont.preferredFont(forTextStyle: .body)}
        return font
    }
}
