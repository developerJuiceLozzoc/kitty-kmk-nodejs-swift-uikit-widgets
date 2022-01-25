//
//  SaveOrDiscardHostingController.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import UIKit
import SwiftUI

class KittyPFPViewModel: ObservableObject {
    @Published var cache = [String:UIImage]()
    
    func loadImage(for imgurl: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: imgurl) else {return}
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                var image: UIImage
                if let data = data, let img = UIImage(data: data) {
                 image = img
                } else {
                    image = UIImage(named: "image-not-found") ?? UIImage()
                }
                DispatchQueue.main.async { [weak self] in
                    guard let wself = self else { return }
                    wself.cache[imgurl] = image
                }

            }
            task.resume()
        }
    }
}

