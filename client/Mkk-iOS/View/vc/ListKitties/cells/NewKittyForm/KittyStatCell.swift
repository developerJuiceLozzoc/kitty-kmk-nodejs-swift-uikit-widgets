//
//  KittyStatCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class KittyStatCell: UITableViewCell {

    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var statContent: UILabel!
    var info: kittystuff? {
        didSet {
            guard let info = self.info else {return}
            statLabel.text = info.pretty
            statContent.text = info.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statLabel.lineBreakMode = .byWordWrapping
        statLabel.numberOfLines = 20
        
        statContent.lineBreakMode = .byWordWrapping
        statContent.numberOfLines = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
