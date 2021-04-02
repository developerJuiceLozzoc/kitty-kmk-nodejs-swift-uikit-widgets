//
//  ContainerViewController.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/1/21
//

import UIKit



class ContainerViewController: UIViewController {
    var animationDurationWithOptions:(TimeInterval, UIView.AnimationOptions) = (0,[])
    fileprivate weak var viewController : UIViewController!
    
    var segueIdentifier: String!
    var datasource: KMKUseViewModel?
    
    @IBInspectable internal var firstLinkedSubView : String!
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        segueIdentifierReceivedFromParent("classic")
    }
    func segueIdentifierReceivedFromParent(_ identifier: String){
        self.segueIdentifier = identifier
        self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            
    }
    

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueIdentifier, let vc = segue.destination as? KMKUseViewModel, let datasource = self.datasource {
        if viewController != nil{
            viewController.view.removeFromSuperview()
            viewController = nil
        }
        
        self.viewController = vc
        vc.votevm = datasource.votevm
        vc.imagesvm = datasource.imagesvm
        
        UIView.transition(with: self.view, duration: animationDurationWithOptions.0, options: animationDurationWithOptions.1, animations: {
            self.addChild(self.viewController)
            self.viewController.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
            self.view.addSubview(self.viewController.view)
        }, completion: { (complete) in
            self.viewController.didMove(toParent: self)
        })
    }
    
    
  }
    

}

