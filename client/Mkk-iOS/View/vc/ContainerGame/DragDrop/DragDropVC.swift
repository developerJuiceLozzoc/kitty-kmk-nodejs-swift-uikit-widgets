//
//  DragDropVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/31/21.
//

import UIKit

class DragDropVC: UIViewController, KMKUseViewModel {
    var votevm: GameSurveyVM? {
        didSet {
            guard let form = votevm?.survey else {return}
            DispatchQueue.main.async {
                self.createForms(with: form)
            }
            votevm?.listenToVoteChanges()
            votevm?.bind {
                guard let form = self.votevm?.survey else {return}
                DispatchQueue.main.async {
                    self.createForms(with: form)
                }
               
            }
        }
    }
    var imagesvm: ImagesViewModel?
    var forms: [VoteRowStack] = []
    
    func createForms(with: GameSurvey ){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
