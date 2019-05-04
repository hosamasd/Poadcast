//
//  DownloadVC.swift
//  Poadcast
//
//  Created by hosam on 5/4/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class DownloadVC: UITableViewController {
    let cellID = "cellID"
    var epoisdes = UserDefaults.standard.downloadedEpoisde()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        epoisdes = UserDefaults.standard.downloadedEpoisde()
        tableView.reloadData()
         UIApplication.getMainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epoisdes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpoisdeCell
        let epoisde = epoisdes[indexPath.row]
        
        cell.epoisde = epoisde
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = self.epoisdes[indexPath.row]
        if index.fileUrl != nil  {
            UIApplication.getMainTabBarController()?.handleMaximizePlayerView(epoisde: index, playlist: self.epoisdes)
        }else {
            let alert = UIAlertController(title: "Item not found", message: "you don't download this item before do you want to watch it stream?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                let acs  = UIAlertAction(title: "OK", style: .default) { (_) in
                     UIApplication.getMainTabBarController()?.handleMaximizePlayerView(epoisde: index, playlist: self.epoisdes)
                }
                alert.addAction(acs)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
            }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func setupTableView()  {
        let nib = UINib(nibName: "EpoisdeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView() // remove lines of cells
    }
}
