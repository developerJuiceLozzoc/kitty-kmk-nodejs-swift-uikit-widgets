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
    
    @IBOutlet weak var activiySpinner: UIActivityIndicatorView!
    var vm = CollectionViewModel()
    
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex;
        DispatchQueue.global().async {
            self.vm.toggleBetweenSameSurveySource(with: index)
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,str) in VOTE_LIST.enumerated() {
            segments.setTitle(str, forSegmentAt: index)
        }
        
        let nib = UINib.init(nibName: "KMKStatsCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "KMKCelebPic")
        activiySpinner.startAnimating()
        vm.loadNextPage(type: segments.selectedSegmentIndex) {
            
            DispatchQueue.main.async {
                self.activiySpinner.stopAnimating()
                self.collectionView.reloadData()

            }
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        
        
        
    }

   

}

extension StatsCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
    }
    
    
}

extension StatsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KMKCelebPic", for: indexPath) as? KMKStatsCell else {return UICollectionViewCell()}
        
        cell.count.setTitle("\(vm.dataSource[indexPath.item].surveys.count)", for: .normal)
        cell.celeb.image = UIImage(systemName: "person.fill.questionmark")
        vm.setCachItemWithLoadedImage(in: segments.selectedSegmentIndex,location: indexPath.item, celeb: vm.dataSource[indexPath.item].cid, imageview: cell.celeb)
        return cell
    }
    
    
}
