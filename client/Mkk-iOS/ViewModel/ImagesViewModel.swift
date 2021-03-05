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
    
    
    func setIndexedImageView(reference imageview: UIImageView, index: Int, with url: URL?){
        guard let url = url else {
            imageview.image = UIImage(systemName: "xmark.octagon")
            return
        }
        URLSession.shared.dataTask(with: url){[weak self] data,resp,err in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let error = err {
                    print (error)
                    imageview.image = UIImage(systemName: "xmark.octagon")
                    return
                }
                if let data = data {
                    imageview.image = UIImage(data: data)
                    self.images[index] = UIImage(data: data)

                }else{
                    imageview.image = UIImage(systemName: "xmark.octagon")

                }
            }
            

        }.resume()
    }
}
