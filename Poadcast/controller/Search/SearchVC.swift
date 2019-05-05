//
//  ViewController.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Alamofire
class SearchVC: UITableViewController {

    let cellID = "cellID"
    var poadcastArray = [PodcastModel]() 
    var timer:  Timer?
//    lazy var searchBar:UISearchBar = {
//       let se = UISearchBar()
//        se.placeholder = "Enter name of podcast"
//        se.delegate = self
//        return se
//    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
    }

    //MARK: -UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poadcastArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        let podcat = poadcastArray[indexPath.row]
        
        cell.podcast = podcat
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let epoisde = EpoisdesVC()
        epoisde.podcast = poadcastArray[indexPath.row]
        navigationController?.pushViewController(epoisde, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No search artist done before!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.poadcastArray.count > 0 ? 0 : 250
    }
    
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    //MARK: -Uuser methods
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter name of podcast"
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView() // remove lines of cells

        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }

}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        poadcastArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0 {
            poadcastArray.removeAll()
            self.tableView.reloadData()
        }
        poadcastArray.removeAll()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
            APIServices.shared.getPodcast(text: searchText) { (pods) in
                self.poadcastArray.append(pods)
                self.tableView.reloadData()
           }
        })
     }
}
