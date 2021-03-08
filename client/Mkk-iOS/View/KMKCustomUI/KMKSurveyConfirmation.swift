//
//  SurveyConfirmation.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/22/21.
//

import UIKit

protocol KMKSurveyConfirmationReader {
    func confirmSurvey()
    func getPhotoForVote(at index: Int) -> UIImage?
}
protocol KMKSurveyConfirmationDataSource {
    func getLabelForCeleb(at index: Int) -> String
}
/*
possible visual swipe indicators
r.joystick.down
 move.3d
 mount
 */
class KMKSurveyConfirmation: UIViewController {
    
    var form: GameSurvey?
    var delegate: KMKSurveyConfirmationReader?
    var datasource: KMKSurveyConfirmationDataSource?

    @IBOutlet var images: [UIImageView]!

    @IBOutlet var names: [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        for view in images {
            UIView.animate(withDuration: 0){
                view.transform = CGAffineTransform(scaleX: 0.001 , y: 0.001)

            }
        }
        for (index,label) in names.enumerated() {
            label.font = UIFont.kmkConfirmation()
            label.text = VOTE_LIST[index]
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        guard let bottom1 = names[0].superview?.bottomAnchor, let bottom2 = names[1].superview?.bottomAnchor, let bottom3 = names[2].superview?.bottomAnchor else {return}
        names[0].bottomAnchor.constraint(equalTo: bottom1, constant:   names[0].bounds.height).isActive = true
        names[1].bottomAnchor.constraint(equalTo: bottom2, constant:   names[1].bounds.height).isActive = true
        names[2].bottomAnchor.constraint(equalTo: bottom3, constant:  names[2].bounds.height).isActive = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let delegate = delegate, let ds = datasource else {return}
        guard let form = self.form else {return}
        for i in 0...2 {
            names[i].text = VOTE_LIST[i]
            self.images[i].image = delegate.getPhotoForVote(at: i)
        }
    }
    override func viewDidAppear(_ animated: Bool) {

        for (delay,view) in images.enumerated() {
            UIView.animate(withDuration: 1,delay: 0.5*Double(delay),usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1 )
                
            }
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard let confirmreader = delegate else {return}
        confirmreader.confirmSurvey()
        performSegue(withIdentifier: "didReviewSurvey", sender: self)


    }
    @IBAction func cancel(_ sender: Any){
        performSegue(withIdentifier: "didReviewSurvey", sender: self)

    }


}
