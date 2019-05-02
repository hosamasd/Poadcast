//
//  MainTabBarVC.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    var maximizeTopAnchorConstraint:NSLayoutConstraint!
    var minimizeTopAnchorConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupViewControllers()
        setupPlayerEpoisdeView()
        
//        perform(#selector(handleMinimizePlayerView), with: nil, afterDelay: 1)
         perform(#selector(handleMaximizePlayerView), with: nil, afterDelay: 3)
    }
    
    //MARK: -USER METHODS
    
    func setupPlayerEpoisdeView()  {
        let players = PlayerEpoisdeView.initFromNib()
        players.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(players, belowSubview: tabBar)
        
        players.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: view.frame.height, left: 0, bottom: 0, right: 0))
        maximizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        print(maximizeTopAnchorConstraint)
        maximizeTopAnchorConstraint.isActive = true
        minimizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
         print(minimizeTopAnchorConstraint)
//        minimizeTopAnchorConstraint.isActive = true
    }
    
    fileprivate func setupViewControllers() {
        
        
        let favorite = templateNavControllerVC(title: "favorite", selectedImage: #imageLiteral(resourceName: "play-button"), rootViewController: FavoriteVC())
        let search = templateNavControllerVC(title: "search", selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC() )
        let download = templateNavControllerVC(title: "downloads", selectedImage: #imageLiteral(resourceName: "download"), rootViewController: DownloadVC())
       
        
        tabBar.tintColor = .black
        
        viewControllers = [
           search ,
            favorite,
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
    minimizeTopAnchorConstraint.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
    })
    }
    
    @objc func handleMaximizePlayerView()  {
        maximizeTopAnchorConstraint.isActive = true
        maximizeTopAnchorConstraint.constant = 0
        minimizeTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
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

