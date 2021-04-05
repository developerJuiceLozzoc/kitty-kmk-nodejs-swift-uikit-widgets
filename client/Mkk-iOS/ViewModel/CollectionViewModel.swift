//
//  CollectionViewModel.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/11/21.
//

import UIKit

class CollectionViewModel {
    var imageCache: [String: CelebBundle] = [:]
    var surveyCache: [String: MongoGameSurvey] = [:]
    
    var dataSource: [KMKCollectionDS] = []
    
    var model: StatModelLoader = StatsModel()
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
        let psize = 69
        let previousOffset = currentOffset
        
        model.loadPageOfCelebs(type: type, offset: previousOffset, amount: psize) { (result) in
            
            switch result {
                case .success(let stuff):
                    self.setupDataSourceForType(for: type, with: stuff)
                    
                    completion()
                    break;
                case .failure(let err):
                    print(err)
                    completion()
                    break;
            }
        }
    }
    
    func setupDataSourceForType(for type: Int, with stuff: CelebResults){
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
            
            guard name.count > 0 else{ continue; }
            
            if let _ = dictionary[name] {
                dictionary[name]!.append(survey._id)
            }
            else{
                dictionary[name] = []
                dictionary[name]!.append(survey._id)
            }
            
            
            guard self.imageCache[name] == nil else {continue}
            let bundle: CelebBundle = CelebBundle(url: stuff.dict[name]!, img: nil)
            self.imageCache[name] = bundle

            
        }
        
        
        self.dataSource = dictionary.keys.map { (key) -> KMKCollectionDS in
            return KMKCollectionDS(cid: key, surveys: dictionary[key] ?? [])
        }

    }
    
    func toggleBetweenSameSurveySource(with type: Int){
        var dictionary: [String: [String] ] = [:]

        for key in surveyCache.keys {
            if let survey = surveyCache[key] {
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
                    
                if let _ = dictionary[name] {
                    dictionary[name]!.append(survey._id)
                }
                else{
                    dictionary[name] = []
                    dictionary[name]!.append(survey._id)
                }
            }
        }
        dataSource = dictionary.keys.map {
            (key) -> KMKCollectionDS in

                return KMKCollectionDS(cid: key, surveys: dictionary[key]!)
        }
            
    }
    
    
}
