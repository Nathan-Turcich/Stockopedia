//
//  FavoritesViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var favoritesList: [String] = []

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
        enableDisableTableView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }

    
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
    
    //Delete Cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = favoritesList.index(of: favoritesList[indexPath.row]) { favoritesList.remove(at: index) }
            if favoritesList.count == 0 { favoritesList.append("")}
            UserDefaults.standard.set(favoritesList, forKey: "FavoriteList")
            enableDisableTableView()
        }
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
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            destination.stockName = favoritesList[tableView.indexPathForSelectedRow!.row]
        }
    }
}
