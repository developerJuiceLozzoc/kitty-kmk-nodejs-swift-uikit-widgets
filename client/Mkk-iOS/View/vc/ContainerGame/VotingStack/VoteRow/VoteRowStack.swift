//
//  VoteRowStack.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit

class VoteRowStack: UIView {

    @IBOutlet weak var celebImage: UIImageView!
    @IBOutlet var radios: [RadioVoteButton]!
    @IBOutlet weak var decor: UIImageView?
    
    
    var state: VoteIdentity?{
        didSet {

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                guard let currentState = self.state else {return}
                for (col,radio) in self.radios.enumerated() {
                    radio.isChecked = false
                    radio.idenity = VoteIdentity(entity: currentState.entity, value: col)
                }
                self.radios[currentState.value].isChecked = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for (index,str) in VOTE_LIST.enumerated() {
            radios[index].setTitle(str, for: .normal)
            radios[index].isChecked = false
            radios[index].idenity = nil
        }
        
        DispatchQueue.global().async {
            NotificationCenter.default.addObserver(
                forName: .radiobttnUpdate,
                object: nil, queue: .current,  using: { [weak self] (notification) in
                    guard let currentState = self?.state else {return}
                    guard let target = notification.object as? SwapRadioButtons else {return}

                    if(currentState == target.e1){
                        self?.state = target.e1
                    }
                    else if(currentState == target.e2){
                        self?.state = target.e2
                    }
            })
        }
        
        
    }
}
