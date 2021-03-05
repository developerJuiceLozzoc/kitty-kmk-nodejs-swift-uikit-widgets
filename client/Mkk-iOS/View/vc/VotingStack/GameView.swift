//
//  MainViewStack.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit

class MainViewStack: UIViewController {
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
    var imagesvm = ImagesViewModel()
    var forms: [VoteRowStack] = []

    
    @IBOutlet var formsViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameSurveyModel().fetchNewGame { (result) in
            switch(result){
                case .success(let survey):
                    self.votevm = GameSurveyVM(with: survey)
                    break
                case .failure(let err):
                    print(err)
                    break;
            }
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        votevm?.listenToVoteChanges()
    }
    override func viewWillDisappear(_ animated: Bool) {
        votevm?.stopListenToVoteChanges()
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
                imagesvm.setIndexedImageView(reference: vrs.celebImage, index: i, with: URL(string: state.celebs[i].imgurl))                
                vrs.frame = .zero
                vrs.translatesAutoresizingMaskIntoConstraints = false
                
                
                formsViews[i].addSubview(vrs)
                forms.append(vrs)

                vrs.anchor(top: formsViews[i].topAnchor, left: formsViews[i].leftAnchor, bottom: formsViews[i].bottomAnchor, right: formsViews[i].rightAnchor)
            }
        }
    }
}


//MARK: - Review and submit
extension MainViewStack {

    @IBAction func reviewAndSubmit(_ sender: Any) {
        guard let survey = votevm?.survey else {return}
        performSegue(withIdentifier: "ConfirmFormSubmissionAlert", sender: survey)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "ConfirmFormSubmissionAlert":
                guard let vc = segue.destination as? KMKSurveyConfirmation else {return}
                vc.form = sender as? GameSurvey
                vc.delegate = self
                vc.datasource = votevm
                break;
            default:
                 return
        }
    }
    
    @IBAction func didReview(_ sender: UIStoryboardSegue){
        /*
         
         do nothing here,it is not necessary to pass data.
         */
    }

}
//MARK confirmation alert sheet
extension MainViewStack: KMKSurveyConfirmationReader {
    func getSurveyPhoto(at index: Int) -> UIImage? {
        return imagesvm.images[index]
    }
    
    func confirmSurvey() {
        votevm?.saveGameResults()
    }
    
    
}
