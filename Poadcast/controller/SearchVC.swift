//
//  ViewController.swift
//  Poadcast
//
//  Created by hosam on 4/30/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class SearchVC: UITableViewController {

    let cellID = "cellID"
    let poadcastArray: [PodcastModel] = [PodcastModel(name: "hosam", artistName: "asd"),
                                         PodcastModel(name: "ahly", artistName: "zag"),
                                         PodcastModel(name: "dad", artistName: "sad")


]
    
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
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poadcastArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podcat = poadcastArray[indexPath.row]
        
        cell.textLabel?.text = "\(podcat.name) \n \(podcat.artistName)"
        cell.textLabel?.numberOfLines = -1
        return cell
    }

    fileprivate func setupSearchBar() {
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
