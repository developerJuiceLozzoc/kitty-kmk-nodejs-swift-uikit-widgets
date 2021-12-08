//
//  KittyConfirmBtnCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class KittyConfirmBtnCell: UITableViewCell {
    
    var delegate: ConfirmKittyable?

    @IBAction func confirm(_ sender: Any) {
        delegate?.confirmAdoption()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
