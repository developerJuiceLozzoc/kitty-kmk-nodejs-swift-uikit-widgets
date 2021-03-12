//
//  CollectionViewModel.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
//

import UIKit
typealias CelebBundle = (url: String, img: UIImage?)
typealias KMKCollectionDS = (cid: String, surveys: [String])

class CollectionViewModel {
    var imageCache: [String: CelebBundle] = [:]
    var surveyCache: [String: MongoGameSurvey] = [:]
    
    var dataSource: [KMKCollectionDS] = []
    
    var model: StatsModel = StatsModel()
    var loader: Loader = ImageLoader()
    var currentOffset: Int = 0
    var reachedEnd: Bool = false


    func setCachItemWithLoadedImage(in cachID: Int, location: Int, celeb: String, imageview: UIImageView){
        guard let bundle = imageCache[celeb] else { return }
        guard let url = URL(string: bundle.url) else {return}

        if let img = bundle.img {
            DispatchQueue.main.async {
                imageview.image = img
            }
            return
        }
        loader.load(url: url) { (result) in
            switch result {
            case .success(let img):
                self.imageCache[celeb] = CelebBundle(url: bundle.url, img: img)
                DispatchQueue.main.async {
                    imageview.image = img

                }
                break
            case .failure( _):
                break
            }
        }
    }
    func loadNextPage(type: Int, completion: @escaping () -> Void){
        let psize = 27
        let previousOffset = currentOffset
        
        model.loadPageOfCelebs(type: type, offset: previousOffset, amount: psize) { (result) in
            
            switch result {
                case .success(let stuff):
                    var dictionary: [String: [String] ] = [:]
                    for survey in stuff.surveys{
                        self.surveyCache[survey._id] = survey
                        
                        var name: String
                        if(type == 0){
                            name = survey.actiona
                        }
                        else if (type == 1){
                            name = survey.actionb
                        }
                        else{
                            name = survey.actionc
                        }
                        guard name.count > 0 else{ break; }
                        let bundle: CelebBundle = CelebBundle(url: stuff.dict[name]!, img: nil)
                        self.imageCache[name] = bundle
                        
                        if let _ = dictionary[name] {
                            dictionary[name]!.append(survey._id)
                        }
                        else{
                            dictionary[name] = []
                            dictionary[name]!.append(survey._id)
                        }
                        
                    }
                    self.dataSource = dictionary.keys.map { (key) -> KMKCollectionDS in
                        return KMKCollectionDS(cid: key, surveys: dictionary[key]!)
                    }
 
                    
                    completion()
                    break;
                case .failure(let err):
                    completion()
                    break;
            }
        }
    }
    
}
