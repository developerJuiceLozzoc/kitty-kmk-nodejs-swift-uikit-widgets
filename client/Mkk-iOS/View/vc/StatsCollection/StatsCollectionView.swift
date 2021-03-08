//
//  StatsCollectionView.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/13/21.
//

import UIKit

class StatsCollectionView: UIViewController {

    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,str) in VOTE_LIST.enumerated() {
            segments.setTitle(str, forSegmentAt: index)
        }
        // Do any additional setup after loading the view.
    }
    

   

}
