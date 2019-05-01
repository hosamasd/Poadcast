//
//  EpoisdesVC.swift
//  Poadcast
//
//  Created by hosam on 5/1/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class EpoisdesVC: UITableViewController {
    let cellID = "cellID"
    var eposdeArray:[EpoisdesModel] = [
    EpoisdesModel(title: "one"),
    EpoisdesModel(title: "two"),
    EpoisdesModel(title: "thress")
    ]
    
    var podcast:PodcastModel? {
        didSet{
            
             navigationItem.title = podcast?.trackName ?? "no title"
            print(podcast?.feedUrl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let epoisde = eposdeArray[indexPath.row]
        
        cell.textLabel?.text = epoisde.title
        
        return cell
    }
 
    func setupTableView()  {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
         tableView.tableFooterView = UIView() // remove lines of cells
    }
}
