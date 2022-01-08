//
//  ImagesViewMOdel.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/23/21.
//

import Foundation
import UIKit

/* image screen
 screen 1 view
 screen 1 view model
 screen 1 model
 */


/*

 what if screen 1 view model, is used
 in another screen, screen 2
 */

class ImagesViewModel {
    var images: [UIImage?] = Array.init(repeating: nil, count: 3)
    var loader: Loader = ImageLoader()
    
    func resetVM(){
        for i in 0..<3{
            images[i] = nil
        }
    }
    func tryRestoreImage(reference: UIImageView, index: Int){
        guard index < images.count, let image = images[index] else{return}
        DispatchQueue.main.async {
            reference.image = image
        }
        
    }
    func setIndexedImageView(reference imageview: UIImageView, index: Int, with url: URL?){
        
        guard let url = url else {
            imageview.image = UIImage(systemName: "xmark.octagon")
            return
        }
        
        guard images[index] == nil else{
            DispatchQueue.main.async {
                imageview.image = self.images[index]

            }
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
