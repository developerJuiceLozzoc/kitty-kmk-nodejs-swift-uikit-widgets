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
            createForms(with: form)
            votevm?.listenToVoteChanges()
        }
    }
    var forms: [VoteRowStack] = []
    
    @IBOutlet var formsViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameSurveyModel.fetchNewGame { (surveyOptional) in
            if let survey = surveyOptional {
                self.votevm = GameSurveyVM(with: survey)
            }
            else{
                print("OOPS say error occured try to pull to refresh.")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
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
                do{
                    vrs.profilepic = UIImage(data: try Data(contentsOf: URL(string:state.celebs[i].imgurl)! ))
                }
                catch _ {}
                
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
                break;
            default:
                 return
        }
    }

}
//MARK confirmation alert sheet
extension MainViewStack: KMKSurveyConfirmationReader {
    func confirmSurvey() {
        votevm?.saveGameResults {
            
        }
    }
    
    
}
