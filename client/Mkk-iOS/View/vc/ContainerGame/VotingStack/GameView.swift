//
//  MainViewStack.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit



class MainViewStack: UIViewController & KMKUseViewModel {
    
    var votevm: GameSurveyVM?
    var imagesvm: ImagesViewModel?
    
    var forms: [VoteRowStack] = []

    @IBOutlet var formsViews: [UIView]!

    override func viewWillAppear(_ animated: Bool) {
        guard let form = votevm?.survey else {return}
        self.createForms(with: form)
        votevm?.listenToVoteChanges()
        votevm?.bind { [unowned self] in
            guard let form = self.votevm?.survey else {return}
            DispatchQueue.main.async {
                self.createForms(with: form)
            }
        }
    }

  
    func createForms(with state: GameSurvey){
        forms = []
        for i in formsViews {
            for view in i.subviews {
                view.removeFromSuperview()
            }
        }
        //------
        for i in 0...2{
            let nib = UINib.init(nibName: "VoteRow", bundle: nil)
            if let vrs = nib.instantiate(withOwner: self, options: nil)[0] as? VoteRowStack {
                vrs.state = VoteIdentity(entity: i, value: i)
                imagesvm?.setIndexedImageView(reference: vrs.celebImage, index: i, with: URL(string: state.celebs[i].imgurl))
                vrs.frame = .zero
                vrs.translatesAutoresizingMaskIntoConstraints = false
                
                
                formsViews[i].addSubview(vrs)
                forms.append(vrs)

                vrs.anchor(top: formsViews[i].topAnchor, left: formsViews[i].leftAnchor, bottom: formsViews[i].bottomAnchor, right: formsViews[i].rightAnchor)
            }
        }
    }
}


