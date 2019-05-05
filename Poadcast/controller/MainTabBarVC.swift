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
    var bottomAnchorConstraint:NSLayoutConstraint!
    
    let players = PlayerEpoisdeView.initFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        setupViewControllers()
        setupPlayerEpoisdeView()
        
    }
    
    //MARK: -USER METHODS
    
    
    fileprivate func setupPlayerEpoisdeView()  {
        
        players.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(players, belowSubview: tabBar)
        
        maximizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = players.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        minimizeTopAnchorConstraint = players.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        players.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        players.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    fileprivate func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
         let favorite = templateNavControllerVC(title: "Favorite", selectedImage: #imageLiteral(resourceName: "star"), rootViewController: FavoriteVC(collectionViewLayout: layout))
        let search = templateNavControllerVC(title: "search", selectedImage: #imageLiteral(resourceName: "search"), rootViewController: SearchVC() )
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
    
    fileprivate func templateNavControllerVC(title: String, selectedImage: UIImage, rootViewController: UIViewController ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navigationController?.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = selectedImage
        return navController
    }
    
    fileprivate func setupViewsAlpha(v1: CGFloat, v2:CGFloat) {
        self.view.layoutIfNeeded()
        self.players.maxStackView.alpha = v1
        self.players.miniPlayerView.alpha = v2
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
            self.setupViewsAlpha(v1: 1, v2: 0)
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        })
    }
    
    //TODO:- HANDLE METHODS
    
    
    
    @objc func handleMinimizePlayerView()  {
        maximizeTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizeTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.setupViewsAlpha(v1: 0, v2: 1)
            self.tabBar.transform = .identity
        })
    }
    
}
