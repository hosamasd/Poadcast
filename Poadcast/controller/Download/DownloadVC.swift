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
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        epoisdes = UserDefaults.standard.downloadedEpoisde()
        tableView.reloadData()
         UIApplication.getMainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    //MARK: -UITableView
    
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadACT = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            let epoisde = self.epoisdes[indexPath.row]
            self.epoisdes.remove(at: indexPath.row)
            UserDefaults.standard.deleteEpoisde(epoi: epoisde)
            tableView.reloadData()
        }
        
        return [downloadACT]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No download list done before!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.epoisdes.count > 0 ? 0 : 250
    }
    
     //MARK: -Uuser methods
    
   fileprivate func setupObservers()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
   fileprivate func setupTableView()  {
        let nib = UINib(nibName: "EpoisdeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView() // remove lines of cells
    }
    
    //TODO: -handle methods
    
    @objc func handleDownloadComplete(notify: Notification){
    guard let object = notify.object as? APIServices.EposdeDownloadCompleteTuple else { return  }
        
        guard let index = self.epoisdes.index(where: {
            $0.title == title
        })else {return}
        self.epoisdes[index].fileUrl = object.filUrl
    }
    
    @objc func handleDownloadProgress(notify: Notification){
        guard let userInfo = notify.userInfo as? [String:Any] else { return  }
        guard let title = userInfo["title"] as? String else { return  }
        guard let progress = userInfo["progress"] as? Double else { return  }
        
       guard let index = self.epoisdes.index(where: {
            $0.title == title
       })else {return}
       guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpoisdeCell else { return  }
        cell.progressLabel.text = "\(Int(progress * 100 ))%"
        cell.progressLabel.isHidden = false
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
       
    }
}
