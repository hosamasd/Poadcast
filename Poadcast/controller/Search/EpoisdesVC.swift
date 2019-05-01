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
    var eposdeArray:[EpoisdesModel] = []
    
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
    
    func fetchEpoisde()  {
        guard let podcastUrl = podcast?.feedUrl else { return  }
        let securePodcastUrl = podcastUrl.contains("https") ? podcastUrl : podcastUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let feedUrl =  URL(string: securePodcastUrl) else { return  }
       let parser = FeedParser(URL: feedUrl)
        parser.parseAsync { (result) in
            
            switch result {
            case let .rss(feed):
                var epoisdes = [EpoisdesModel]()
                feed.items?.forEach({ (feedItem) in
                 
                    let epoisde = EpoisdesModel(feed: feedItem)
                    epoisdes.append(epoisde)
                })
                
                self.eposdeArray = epoisdes
                DispatchQueue.main.async {
                     self.tableView.reloadData()
                }
               
                break
            case let .failure(error):
                print("not found",error)
                break
            default:
                print("load feed .....")
            }
        }
    }
}
