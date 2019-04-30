//
//  MainTabBarVC.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupViewControllers()
    }
    
    //MARK: -USER METHODS
    
    fileprivate func setupViewControllers() {
        
        
        let favorite = templateNavControllerVC(title: "favorite", selectedImage: #imageLiteral(resourceName: "play-button"), rootViewController: FavoriteVC())
        let search = templateNavControllerVC(title: "search", selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchVC() )
        let download = templateNavControllerVC(title: "downloads", selectedImage: #imageLiteral(resourceName: "download"), rootViewController: DownloadVC())
       
        
        tabBar.tintColor = .black
        
        viewControllers = [
            favorite,
            search,
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

