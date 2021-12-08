//
//  ScheduleKitty.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class ScheduleKitty: UIViewController {
    let network: CatApier = KittyJsoner()
    var FeatureTogglesLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summonBttn.showLoading()
        if(ZeusToggles.shared.didLoad){
            summonBttn.hideLoading()
            FeatureTogglesLoaded = true
        } else {
            summonBttn.showLoading()
        }

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageresult: UIImageView!
    @IBOutlet weak var message: LoadingButton!
    
    @IBOutlet weak var summonBttn: LoadingButton!
    
    @IBAction func scheduleConfirm(_ sender: Any) {
        guard ZeusToggles.shared.didLoad else { return }
        if(!FeatureTogglesLoaded) {
            summonBttn.hideLoading()
            FeatureTogglesLoaded = true
        }

        guard let DeviceToken = UserDefaults.standard.value(forKey: "FCMDeviceToken") as? String else {
            let kitty:UIImage? = UIImage(named:"pets-field-flowers-two-")
            let message: String = "You need to enable Push Notifications for this app. please visit settings"
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2,animations: {
                    self.imageresult.image = kitty
                    self.message.setTitle(message, for: .normal)
                }, completion: nil)
            }
            return}
        
        summonBttn.setTitle("Please wait ...", for: .normal)
        message.setTitle("We have now called out and are waiting for response from the ether.", for: .normal)
        
        network.postNewNotification(withDeviceName: DeviceToken) { (result) in
            var kitty:UIImage? = nil
            var message: String = ""
            DispatchQueue.main.async {
                self.summonBttn.setTitle("Summon Cat", for: .normal)
            }
            
            
            switch result {
                case .success(_):
                    kitty = UIImage(named:"kittens-drinking-milk")
                    message = "Your call has been answered for kitty, the milk offering has been accepted."
                if(ZeusToggles.shared.toggles.instantPushKitty){
                    // post to the server to dilver notification instantly
                    self.network.dispatchNotificationsImmediately { result in
                        switch result {
                        case .success( _):
                            return
                        case .failure(let err):
                            print(err)
                            kitty = UIImage(named:"roxy-butt")

                            message = "Failed to dispatch notification sorry"
                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2,animations: {
                                    self.imageresult.image = kitty
                                    self.message.setTitle(message, for: .normal)
                                }, completion: nil)
                            }
                        }
                    }
                }
                
                
                
                
                case .failure(let e):
                    print(e)
                    switch e {
                    case .invalidClientRequest:
                        kitty = UIImage(named:"pets-field-flowers-two-")
                        message = "Hold up, we can only dispatch One kitty spirit per day, or you already have a pending notification for new encounter."
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
