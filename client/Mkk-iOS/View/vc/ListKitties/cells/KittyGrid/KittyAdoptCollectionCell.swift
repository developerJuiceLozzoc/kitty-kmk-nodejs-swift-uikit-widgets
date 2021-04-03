//
//  KittyAdoptCollectionCell.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/3/21.
//

import UIKit

class KittyAdoptCollectionCell: UITableViewCell {

    @IBOutlet weak var collection: UICollectionView!
    var urls: [String]? {
        didSet {
            guard let urls = self.urls else {return}
            for _ in urls {
                imgvm.images.append(nil)
            }
        }
    }
    var selectedItem: Int? = nil
    var imgvm = ImagesViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvm.images = []
        collection.dataSource = self;
        collection.delegate = self;
        
        let nib2 = UINib.init(nibName: "SelfieClickCell", bundle: nil)
        collection.register(nib2, forCellWithReuseIdentifier: "CelebCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectNewItem(with index: Int){
        selectedItem = index
        collection.reloadData()
    }
    
}
extension KittyAdoptCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgvm.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "CelebCell", for: indexPath) as? SelfieClickCell else {return UICollectionViewCell()}
        
        cell.id = indexPath.item
        cell.isAdoptReady = false
        cell.delegate = self
        
        
//        print(urls?[indexPath.item])
        
        if let urls = self.urls, let url = URL(string: urls[indexPath.item]) {
            imgvm.setIndexedImageView(reference: cell.imageView, index: indexPath.item, with: url)
        }
        
        
        guard let currId = self.selectedItem else {return cell}
        cell.isAdoptReady = indexPath.item == currId
        
        
        return cell
        
    }
    
      
}
