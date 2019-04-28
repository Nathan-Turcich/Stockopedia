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
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var loggedInView: UIView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    var favoritesList: [(abbr: String, fullName: String)] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        Utils.getPossibleUser()
        if currentID != "" {
            logInView.isHidden = true; logInView.isUserInteractionEnabled = false
            loggedInView.isHidden = false; loggedInView.isUserInteractionEnabled = true
            downloadFavortiesList()
            loadingStarted()
        }
        else {
            logInView.isHidden = false; logInView.isUserInteractionEnabled = true
            loggedInView.isHidden = true; loggedInView.isUserInteractionEnabled = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    func downloadFavortiesList(){
        DownloadData.downloadUserFavoritedList(key: currentID, completion: { (list) in
            if let favs = list {
                if list?.count == 0 {
                    DispatchQueue.main.async {
                        self.tableView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.noFavoritesLabel.isHidden = false
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.favoritesList = favs
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.tableView.allowsSelection = true
                        self.tableView.separatorStyle = .singleLine
                        self.tableView.isScrollEnabled = true
                        self.activityIndicator.stopAnimating()
                        self.noFavoritesLabel.isHidden = true
                    }
                }
            }
            else { print("Error getting data") }
        })
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return favoritesList.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoritesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesTableViewCell
        cell.favoritesAbbrLabel.text = favoritesList[indexPath.row].abbr
        cell.favoritesFullNameLabel.text = favoritesList[indexPath.row].fullName
        return cell
    }
    
    //Delete Cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
            print(favoritesList[indexPath.row])
            DownloadData.deleteNameFavoritedList(key: currentID, abbr: favoritesList[indexPath.row].abbr)
            favoritesList.remove(at: indexPath.row)
            tableView.reloadData()
            if favoritesList.count == 0 { viewWillAppear(false)}
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
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            destination.stockAbbr = favoritesList[(tableView.indexPathForSelectedRow?.row)!].abbr
            destination.stockName = favoritesList[(tableView.indexPathForSelectedRow?.row)!].fullName
        }
    }
}
