//
//  ImagesViewMOdel.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/23/21.
//

import Foundation
import UIKit

class ImagesViewModel {
    var images: [UIImage?] = Array.init(repeating: UIImage(), count: 3)
    var loader: Loader = ImageLoader()
    
    func setIndexedImageView(reference imageview: UIImageView, index: Int, with url: URL?){
        guard let url = url else {
            imageview.image = UIImage(systemName: "xmark.octagon")
            return
        }
        loader.load(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let img):
                        imageview.image = img
                        self.images[index] = img
                        break
                    case .failure(let err):
                        print(err)
                        self.images[index] = UIImage(systemName: "xmark.octagon")
                }
            }
            
        }
    }
}
