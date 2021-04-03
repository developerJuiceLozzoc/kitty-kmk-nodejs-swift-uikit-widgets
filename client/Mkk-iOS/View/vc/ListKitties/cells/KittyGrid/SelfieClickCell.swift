//
//  SelfieClickCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class SelfieClickCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    var delegate: KittyAdoptCollectionCell?
    var id: Int?
    var isAdoptReady: Bool = false {
        didSet{
            if(isAdoptReady){
                btn.backgroundColor = UIColor(red: 38.0/255, green: 166.0/255, blue: 91.0/255, alpha: 0.6)
                btn.setTitle("Selected", for: .normal)
            }
            else{
                btn.backgroundColor = .clear
                btn.setTitle("Adopt", for: .normal)
            }
        }
    }
    
    
    @IBAction func click(_ sender: Any) {
        guard let id = self.id else {return}
        delegate?.selectNewItem(with: id)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
