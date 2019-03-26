//
//  FavoritesViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var favoritesList: [String] = []
var noFavorites = true

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]

        if favoritesList.count == 0 || favoritesList[0] == "" {
            favoritesList.append("")
            favoritesList.append("")
            favoritesList.append("You currently have no favorite stocks")
            tableView.isScrollEnabled = false
            tableView.rowHeight = 100
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            noFavorites = true
            tableView.reloadData()
        }
        else {
            noFavorites = false
            tableView.reloadData()
        }
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return favoritesList.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesTableViewCell
        cell.favoritesStockLabel.text = favoritesList[indexPath.row]
        
        if noFavorites == true {
            cell.favoritesStockLabel.font = UIFont.boldSystemFont(ofSize: 30)
            cell.favoritesStockLabel.numberOfLines = 2
            cell.favoritesStockLabel.textAlignment = .center
        }
        return cell
    }
}
