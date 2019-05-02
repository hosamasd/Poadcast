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
        main?.handleMaximizePlayerView(epoisde: index)
        
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
