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
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
        enableDisableTableView()
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return favoritesList.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesTableViewCell
        cell.favoritesStockLabel.text = favoritesList[indexPath.row]
        cell.favoritesStockLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.favoritesStockLabel.numberOfLines = 1
        cell.favoritesStockLabel.textAlignment = .left
        return cell
    }
    
    func enableDisableTableView(){
        if favoritesList[0] != "" {
            if favoritesList[0] == "" { favoritesList.remove(at: 0) }
            tableView.isHidden = false
            tableView.isScrollEnabled = true
            tableView.rowHeight = 30
            tableView.separatorStyle = .singleLine
            tableView.allowsSelection = true
            tableView.reloadData()
            noFavoritesLabel.isHidden = true
        }
        else {
            tableView.isHidden = true
            tableView.isScrollEnabled = false
            noFavoritesLabel.isHidden = false
        }
    }
}
