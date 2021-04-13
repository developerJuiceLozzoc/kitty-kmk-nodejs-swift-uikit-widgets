//
//  ScheduleKitty.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class ScheduleKitty: UIViewController {
    let re = RealmCrud()
    let network: CatApier = KittyJsoner()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageresult: UIImageView!
    @IBOutlet weak var message: UIButton!
    
    
    @IBAction func scheduleConfirm(_ sender: Any) {
        print("sending schedule")
        guard let DeviceToken = UserDefaults.standard.value(forKey: "FCMDeviceToken") as? String else {return}
        
        network.postNewNotification(withDeviceName: DeviceToken) { (result) in
            var kitty:UIImage? = nil
            var message: String = ""
            switch result {
                case .success(_):
                    kitty = UIImage(named:"kittens-drinking-milk")
                    message = "Your call has been answered for kitty, the milk offering has been accepted."
                case .failure(let e):
                    print(e)
                    switch e {
                    case .invalidClientRequest:
                        kitty = UIImage(named:"pets-field-flowers-two-")
                        message = "Hold up, we can only dispatch One kitty spirit per day"
                        break;
                    default:
                        kitty = UIImage(named:"roxy-butt")
                        message = "The sky kitties are not in the mood today, try again later."
                    }
                    
            }
            

            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2,animations: {
                    self.imageresult.image = kitty
                    self.message.setTitle(message, for: .normal)
                }, completion: nil)
            }
            
        }
        
    }

}
