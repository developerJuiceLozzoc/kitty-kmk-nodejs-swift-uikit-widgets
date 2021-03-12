//
//  KMKStatsCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 3/12/21.
//

import UIKit

class KMKStatsCell: UICollectionViewCell {

    @IBOutlet weak var count: UIButton!
    @IBOutlet weak var celeb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        count.setTitleColor(UIColor(named: "Lipstick")!, for: .selected)
        count.layer.cornerRadius = 10
    }

}
