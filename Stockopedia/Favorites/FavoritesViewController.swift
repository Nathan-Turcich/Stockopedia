//
//  FavoritesViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit


class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    let activityIndicator = UIActivityIndicatorView()
    var favoritesList: [String] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        loadingStarted()
        DownloadData.downloadFavoritedList(key: "1", completion: { (list) in
            if let favs = list {
                if list?.count == 0 {
                    self.tableView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.noFavoritesLabel.isHidden = false
                }
                else{
                    DispatchQueue.main.async {
                        self.favoritesList = favs
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.tableView.isScrollEnabled = true
                        self.tableView.separatorStyle = .singleLine
                        self.tableView.allowsSelection = true
                        self.noFavoritesLabel.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            else { print("Error getting data") }
        })
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return favoritesList.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesTableViewCell
        cell.favoritesStockLabel.text = favoritesList[indexPath.row]
        return cell
    }
    
    //Delete Cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DownloadData.deleteNameFavoritedList(key: currentUserID, name: favoritedList[indexPath.row])
        }
    }
    
    //MARK: Loading Data
    func loadingStarted(){
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.noFavoritesLabel.isHidden = true
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            destination.stockName = favoritesList[tableView.indexPathForSelectedRow!.row]
        }
    }
}
