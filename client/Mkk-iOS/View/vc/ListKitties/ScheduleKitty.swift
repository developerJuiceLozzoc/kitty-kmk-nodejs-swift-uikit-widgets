//
//  ScheduleKitty.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class ScheduleKitty: UIViewController {

    let network: CatApier = KittyJsoner()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func scheduleConfirm(_ sender: Any) {
        print("sending schedule")
        guard let DeviceToken = UserDefaults.standard.value(forKey: "FCMDeviceToken") as? String else {return}
        
        network.postNewNotification(withDeviceName: DeviceToken) { (result) in
            switch result {
                case .success(let _):
                    print("alert user of impending kitty")
                case .failure(let e):
                    print(e)
                    print("present a pity kitty")
            }
        }
        
    }
    
   
}
