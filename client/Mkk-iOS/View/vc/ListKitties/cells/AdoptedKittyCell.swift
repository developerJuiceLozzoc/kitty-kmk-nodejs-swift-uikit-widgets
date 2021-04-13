//
//  AdoptedKittyCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit
import SwipeCellKit


class AdoptedKittyCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
