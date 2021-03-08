//
//  RadioVoteButton.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit

class RadioVoteButton: UIButton {
    var idenity: VoteIdentity?

    var isChecked: Bool = false {
        didSet {
            UIView.animateKeyframes(withDuration: 0.75, delay: 0, options: .calculationModeCubic, animations: {
                if(self.isChecked == true){
                    self.backgroundColor = UIColor.separator
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.3)
                    self.tintColor = .black
                }
                else{
                    self.backgroundColor = .clear
                    self.tintColor = UIColor(named: "Lipstick")
                }
            }, completion: nil)
            
        }
    }
    
    override func awakeFromNib() {
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.titleLabel?.numberOfLines = 3
        self.titleLabel?.lineBreakMode = .byWordWrapping
    }
            
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked.toggle()
        }
        guard let voteid = idenity else {return}
        NotificationCenter.default.post(name: .voteDidChange,object: voteid)
        
        
    }

    
}
