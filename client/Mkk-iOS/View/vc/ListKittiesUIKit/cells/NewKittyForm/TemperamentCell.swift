//
//  TemperamentCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/4/21.
//

import UIKit

class TemperamentCell: UITableViewCell {
    var datasource: [String]? {
        didSet {
            guard let datasource = self.datasource else {return}
            DispatchQueue.main.async {
                self.createLabels(with: datasource)
            }
            
        }
    }
    
    @IBOutlet var hstacks: [UIStackView]!
    
    @IBOutlet var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func createLabels(with datasource: [String]){

        let spaceGray = UIColor(red: 113.0/255, green: 119.0/255, blue: 134.0/255, alpha: 1)
        
        for (index,str) in datasource.enumerated() {

            labels[index].text = str
            labels[index].numberOfLines = 2
            labels[index].lineBreakMode = .byWordWrapping
            labels[index].text = str
            labels[index].backgroundColor = spaceGray.withAlphaComponent(0.2)
            
            labels[index].layer.borderWidth = 0.8
            labels[index].layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            labels[index].layer.cornerRadius = 7
            
            labels[index].layer.shadowColor = spaceGray.cgColor
            labels[index].layer.shadowOpacity = 0.8
            labels[index].layer.shadowRadius = 12
            labels[index].layer.shadowOffset = CGSize(width: 1, height: 1)
//            labels[index].append(label)
        }
       let rows: Int = datasource.count / 3 + 1

        if(rows < 3){
            hstacks[2].removeFromSuperview()
        }
        
//        DispatchQueue.main.async {
//            self.placeUI(with: labels)
//        }
    }
//    func placeUI(with labels: [UILabel]){
//        guard let datasource = self.datasource else {return}
//        let rows: Int = datasource.count / 3 + 1
//
//
//        var hstack: UIStackView
//        for row in 0..<rows {
//            hstack = UIStackView()
//            hstack.frame = .zero
//            hstack.axis = .horizontal
//            hstack.distribution = .fillEqually
//            hstack.spacing = 3
//            for col in 0...2{
//                if(row+col < labels.count){
//                    hstack.addSubview(labels[row+col])
//                }
//            }
//            stack.addSubview(hstack)
//        }
//
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height * 0.062 * CGFloat(rows)).isActive = true
//        stack.distribution = .fillEqually
//        stack.spacing = 5
//        print(stack.subviews)
//
//
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
