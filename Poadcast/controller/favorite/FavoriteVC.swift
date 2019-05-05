//
//  FavoriteVC.swift
//  Poadcast
//
//  Created by hosam on 5/4/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class FavoriteVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var podcasts = UserDefaults.standard.savePodcasts()
    
   override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savePodcasts()
        collectionView.reloadData()
        
        UIApplication.getMainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    
    //MARK: -UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCell
        let pods = podcasts[indexPath.item]
        
        cell.podcasts = pods
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = podcasts[indexPath.item]
        
        let epoisde = EpoisdesVC()
        epoisde.podcast = index
        
        navigationController?.pushViewController(epoisde, animated: true)
    }
    
    //MARK:-USER METHODS
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLonePressed)))
    }
    
   func createAlert(title:String, message: String,index:IndexPath,pod:PodcastModel)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let acs  = UIAlertAction(title: "OK", style: .destructive) { (tx) in
            self.podcasts.remove(at: index.item)
             UserDefaults.standard.deletePodcast(pod: pod)
            self.collectionView.deleteItems(at: [index])

        }
        alert.addAction(acs)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //TODO: -handle methods
    
    @objc func handleLonePressed(gest: UILongPressGestureRecognizer){
        let p = gest.location(in: collectionView)
        guard  let indexPath = collectionView.indexPathForItem(at: p) else {return}
        let pods = podcasts[indexPath.item]

        let location = gest.location(in: collectionView)
       
        guard  let index = collectionView.indexPathForItem(at: location) else {return }
   
        createAlert(title: "Remove Item?", message: "do you want to delete this item?", index: index, pod:pods )
        
    }
}
