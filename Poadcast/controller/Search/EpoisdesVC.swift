//
//  EpoisdesVC.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import FeedKit

class EpoisdesVC: UITableViewController {
    let cellID = "cellID"
    var eposdeArray = [EpoisdesModel]()
    
    var podcast:PodcastModel? {
        didSet{
            
             navigationItem.title = podcast?.trackName ?? "no title"
            fetchEpoisde()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupTableView()
         setupNvaigationItemsButton()
    }
    
    
    func setupNvaigationItemsButton()  {
        let savedPodcasts = UserDefaults.standard.savePodcasts()
        
        let hasFavorite = savedPodcasts.index(where: {
            $0.artistName == self.podcast?.artistName &&
            $0.trackName == self.podcast?.trackName
        }) != nil
        
        if hasFavorite {
            // heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUnLike))
        }else{
        
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleFavorit))
        
        }
    }
    
    @objc func handleUnLike(){
        print(222)
    }
    
    @objc func handleFetch(){
        print("fetch")
        guard let keys = UserDefaults.standard.data(forKey: UserDefaults.ketTrack) else {return}
        do {
            let podcasts = NSKeyedUnarchiver.unarchiveObject(with: keys) as? [PodcastModel]
            
            podcasts?.forEach({ (p) in
                print(p.trackName ?? "")
            })
        } catch let err {
            print("can not loaded saved data ",err.localizedDescription)
        }
        
        
    }
    @objc func handleFavorit(){
      guard  let podcaset = self.podcast else {return}
        //podcast to data
        do {
            var listOfPodcast = UserDefaults.standard.savePodcasts()
            listOfPodcast.append(podcaset)
           let data =   try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
             UserDefaults.standard.set(data, forKey: UserDefaults.ketTrack)
        } catch let err {
            print("can not to saveed ",err.localizedDescription)
        }
        
     
        showHighlightTapped()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUnLike))
    }
    func showHighlightTapped()  {
        UIApplication.getMainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "new"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eposdeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpoisdeCell
        let epoisde = eposdeArray[indexPath.row]
        
        cell.epoisde = epoisde
        
        return cell
    }
 
    func setupTableView()  {
        let nib = UINib(nibName: "EpoisdeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
         tableView.tableFooterView = UIView() // remove lines of cells
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatpr = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatpr.color = .darkGray
        activityIndicatpr.startAnimating()
        return activityIndicatpr
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return eposdeArray.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = eposdeArray[indexPath.row]
        
        let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC
        main?.handleMaximizePlayerView(epoisde: index,playlist: self.eposdeArray)
        
//        let playerEpoisdeView = PlayerEpoisdeView.initFromNib()
//        playerEpoisdeView.epoisde = index
//        playerEpoisdeView.frame = view.frame
//
//        let window = UIApplication.shared.keyWindow
//        window?.addSubview(playerEpoisdeView)
        
        
    }
    func fetchEpoisde()  {
        guard let podcastUrl = podcast?.feedUrl else { return  }
        
        APIServices.shared.fetchEpoisdes(feedUrl: podcastUrl) { (epoisde) in
            self.eposdeArray = epoisde
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
