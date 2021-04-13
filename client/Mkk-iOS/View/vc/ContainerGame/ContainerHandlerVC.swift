//
//  ContainerHandlerVC.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/1/21
//

import UIKit


class ContainerHandlerVC: UIViewController, KMKUseViewModel {
    
    var container: ContainerViewController!
    var votevm: GameSurveyVM?
    var imagesvm: ImagesViewModel? = ImagesViewModel()
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    @IBAction func segmentChagne(_ sender: Any) {
        guard let sender = sender as? UISegmentedControl else {return}
        if sender.selectedSegmentIndex == 0{
            container.segueIdentifierReceivedFromParent("classic")
        }else{
            container.segueIdentifierReceivedFromParent("dragndrop")

        }
    }
    
    @IBAction func ToReview(_ sender: Any) {
        
        guard let survey = votevm?.survey else {print("no survey");return}
        performSegue(withIdentifier: "ConfirmFormSubmissionAlert", sender: survey)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // the automatic embeded segue
        if segue.identifier == "container"{
            self.container = segue.destination as? ContainerViewController
            container?.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
            container?.datasource = self
        }
        else if segue.identifier == "ConfirmFormSubmissionAlert" {

            guard let vc = segue.destination as? KMKSurveyConfirmation else {return}
            vc.form = sender as? GameSurvey
            vc.delegate = self
            
        }
    }
    
    

}

//MARK: - View lifecycle
extension ContainerHandlerVC {
    override func viewWillAppear(_ animated: Bool) {

        guard votevm == nil else {return}
        activitySpinner.startAnimating()
        self.activitySpinner.color = .black
        GameSurveyModel().fetchNewGame { (result) in
            switch(result){
                case .success(let survey):
                    DispatchQueue.main.async{
                        self.activitySpinner.stopAnimating()
                        self.votevm = GameSurveyVM(with: survey)
                        self.container.segueIdentifierReceivedFromParent("classic")
                    }
                    break
                case .failure(let err):
                    DispatchQueue.main.async{
                        self.activitySpinner.stopAnimating()
                        self.activitySpinner.color = .red
                    }
                    print(err)
                    break;
            }
        }
        votevm?.listenToVoteChanges()
    }
    override func viewWillDisappear(_ animated: Bool) {
        votevm?.stopListenToVoteChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Initialize a gradient view
//        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//
//        // Set the gradient colors
//        gradientView.colors = [UIColor(named: "salmon")!, UIColor(named: "plumred")!,UIColor(named: "dark-red")!]
//
//
//        // Optionally set some locations
//        // Add it as a subview in all of its awesome
//        self.gradient.addSubview(gradientView)
        
        
    }

}

//MARK: - Review and submit
extension ContainerHandlerVC {

    @IBAction func reviewAndSubmit(_ sender: Any) {
        
        
    }
    
    @IBAction func didReview(_ sender: UIStoryboardSegue){
        /*
         
         do nothing here,it is not necessary to pass data.
         */
    }

}



//MARK: - ViewModel request methods
extension ContainerHandlerVC: KMKSurveyConfirmationReader {
    func getPhotoForVote(at index: Int) -> UIImage? {
        guard let i = votevm?.survey?.votes.firstIndex(of: index) else {return nil}

        return imagesvm?.images[i]

    }
    
    func confirmSurvey() {
        imagesvm?.resetVM()
        votevm?.saveGameResults()
    }
    
    
}
