//
//  MainTabBarVC.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
     let players = PlayerEpoisdeView.initFromNib()
    var maximizeTopAnchorConstraint:NSLayoutConstraint!
    var minimizeTopAnchorConstraint:NSLayoutConstraint!
     var bottomAnchorConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupViewControllers()
        setupPlayerEpoisdeView()
       
//        perform(#selector(handleMinimizePlayerView), with: nil, afterDelay: 1)
//         perform(#selector(handleMaximizePlayerView), with: nil, afterDelay: 1)
    }
    
    //MARK: -USER METHODS
    
   
    func setupPlayerEpoisdeView()  {
       
        players.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(players, belowSubview: tabBar)
        
//        players.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: view.frame.height, left: 0, bottom: view.frame.height, right: 0))
        maximizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = players.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        minimizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        players.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        players.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        minimizeTopAnchorConstraint.isActive = true
    }
    
    fileprivate func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        
        
        let favorite = templateNavControllerVC(title: "Favorite", selectedImage: #imageLiteral(resourceName: "play-button"), rootViewController: FavoriteVC(collectionViewLayout: layout))
        let search = templateNavControllerVC(title: "search", selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC() )
        let download = templateNavControllerVC(title: "Downloads", selectedImage: #imageLiteral(resourceName: "download"), rootViewController: DownloadVC())
       
        
        tabBar.tintColor = .black
        
        viewControllers = [
            
            favorite,
           search ,
            download
            ]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    
    fileprivate func templateNavControllerVC(title: String, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.title = title
       navController.tabBarItem.image = selectedImage
        return navController
    }
    
    //TODO:- HANDLE METHODS
    
   @objc func handleMinimizePlayerView()  {
        maximizeTopAnchorConstraint.isActive = false
    bottomAnchorConstraint.constant = view.frame.height
    minimizeTopAnchorConstraint.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
         self.tabBar.transform = .identity
        
        self.players.maxStackView.alpha = 0
        self.players.miniPlayerView.alpha = 1
    })
    }
    
    func handleMaximizePlayerView(epoisde:EpoisdesModel?,playlist: [EpoisdesModel] = [])  {
        minimizeTopAnchorConstraint.isActive = false
        maximizeTopAnchorConstraint.isActive = true
        maximizeTopAnchorConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        if epoisde != nil {
             players.epoisde = epoisde
        }
       
        players.playListEpoisde = playlist
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.players.maxStackView.alpha = 1
            self.players.miniPlayerView.alpha = 0
        })
    }
    
}
//extension MainTabBarVC: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let index = tabBarController.viewControllers?.index(of: viewController)
//        if index == 2 {
//            let photo = PhotoSelectorVC(collectionViewLayout: UICollectionViewFlowLayout())
//            let nav = UINavigationController(rootViewController: photo)
//
//            present(nav, animated: true, completion: nil)
//
//            return false
//        }
//        return true
//
//    }
//}

