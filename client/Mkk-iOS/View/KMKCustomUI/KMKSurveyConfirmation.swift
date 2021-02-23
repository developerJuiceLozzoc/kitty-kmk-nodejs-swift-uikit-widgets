//
//  SurveyConfirmation.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/22/21.
//

import UIKit

protocol KMKSurveyConfirmationReader {
    func confirmSurvey()
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

    @IBOutlet var images: [UIImageView]!

    @IBOutlet var names: [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let form = self.form else {return}
        for label in names {
            label.font = UIFont.kmkMain()
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard let confirmreader = delegate else {return}
        confirmreader.confirmSurvey()
    }

    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        print(unwindSegue)
        
    }

}
