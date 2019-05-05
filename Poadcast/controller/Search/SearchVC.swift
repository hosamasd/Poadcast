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
    lazy var searchBar:UISearchBar = {
       let se = UISearchBar()
        se.placeholder = "enter name"
        se.delegate = self
        
        return se
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "Voong")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poadcastArray.count
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let epoisde = EpoisdesVC()
        epoisde.podcast = poadcastArray[indexPath.row]
        navigationController?.pushViewController(epoisde, animated: true)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "no search artist done before!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.poadcastArray.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        let podcat = poadcastArray[indexPath.row]
        
        cell.podcast = podcat
//        cell.textLabel?.numberOfLines = -1
//        cell.imageView?.image = #imageLiteral(resourceName: "music")
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    fileprivate func setupSearchBar() {
        // Do any additional setup after loading the view, typically from a nib.
        self.definesPresentationContext = true
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView() // remove lines of cells

        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }

}

extension SearchVC: UISearchBarDelegate {
    
    
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
