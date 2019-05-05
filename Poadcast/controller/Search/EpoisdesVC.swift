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
    
    //MARK: -UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eposdeArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpoisdeCell
        let epoisde = eposdeArray[indexPath.row]
        
        cell.epoisde = epoisde
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadACT = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            let epoisde = self.eposdeArray[indexPath.row]
            UserDefaults.standard.downloadEpoisde(epoisde: epoisde)
            self.showHighlightTapped(index: 2, text: "New")
            
            APIServices.shared.downloadEpoisde(epoisde: epoisde)
        }
        
        return [downloadACT]
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
        
        guard let main = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC else {return}
        main.handleMaximizePlayerView(epoisde: index,playlist: self.eposdeArray)
    }
    
    //MARK: -Uuser methods
    
    var hasFavorite = false
    
    fileprivate func checkFavorites(fav:Bool) {
        if hasFavorite {
            // heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUnLike))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleFavorit))
        }
    }
    
    fileprivate func setupNvaigationItemsButton()  {
        let savedPodcasts = UserDefaults.standard.savePodcasts()
        
        hasFavorite = savedPodcasts.index(where: {
            $0.artistName == self.podcast?.artistName &&
                $0.trackName == self.podcast?.trackName
        }) != nil
        
        checkFavorites(fav: hasFavorite)
    }
    
   fileprivate func setupTableView()  {
        let nib = UINib(nibName: "EpoisdeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView() // remove lines of cells
    }
    
   fileprivate func showHighlightTapped(index: Int,text: String)  {
        UIApplication.getMainTabBarController()?.viewControllers?[index].tabBarItem.badgeValue = text
    }
    
  fileprivate  func fetchEpoisde()  {
        guard let podcastUrl = podcast?.feedUrl else { return  }
        
        APIServices.shared.fetchEpoisdes(feedUrl: podcastUrl) { (epoisde) in
            self.eposdeArray = epoisde
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
   fileprivate func createAlert(title:String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //TODO: -handle methods
    
    @objc func handleUnLike(){
        guard let podcast = self.podcast else { return  }
        
        UserDefaults.standard.deletePodcast(pod: podcast)
        hasFavorite = false
        
        checkFavorites(fav: hasFavorite)
        showHighlightTapped(index: 0, text: "Remove")
    }
    
    @objc func handleFetch(){
        
        guard let keys = UserDefaults.standard.data(forKey: UserDefaults.ketTrack) else {return}
        
        let podcasts = NSKeyedUnarchiver.unarchiveObject(with: keys) as? [PodcastModel]
    }
    
    @objc func handleFavorit(){
        guard  let podcaset = self.podcast else {return}
        
        var listOfPodcast = UserDefaults.standard.savePodcasts()
        listOfPodcast.append(podcaset)
        do {
            let data =   try NSKeyedArchiver.archivedData(withRootObject: listOfPodcast, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.ketTrack)
        } catch let err {
            createAlert(title: "Error", message: err.localizedDescription)
        }
        
        showHighlightTapped(index: 0, text: "New")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUnLike))
    }
    
    
    
}
