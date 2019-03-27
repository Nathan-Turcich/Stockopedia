//
//  StockViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StockCellDelegate, HStockProtocol {
    
    //MARK: - Variables
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var stocks: [String] = []
    var filteredStocks: [String] = []
    let hstock = HStock()
    let activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        hstock.delegate = self
        hstock.downloadItems()
        loadingStarted()
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableView.indexPathForSelectedRow != nil { tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true) }
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.height), animated: true)
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
        tableView.reloadData()
    }
    
    //MARK: - Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filteredStocks.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "allStocksCell") as! StockTableViewCell
        cell.stockNameLabel.text = filteredStocks[indexPath.row]
        cell.stockNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        if favoritesList.contains(filteredStocks[indexPath.row]) {
            cell.favoriteButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)
        }
        else { cell.favoriteButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}
        cell.delegate = self
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    func btnCloseTapped(cell: StockTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        if cell.favoriteButton.currentImage == UIImage(named: "favoritesFilled") {
            UIView.transition(with: cell.favoriteButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favoriteButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}, completion: (nil))
            if let index = favoritesList.index(of: stocks[indexPath!.row]) {
                favoritesList.remove(at: index)
            }
        }
        else{
            if favoritesList[0] == "" { favoritesList.remove(at: 0)}
            UIView.transition(with: cell.favoriteButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favoriteButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)}, completion: (nil))
            favoritesList.append(stocks[indexPath!.row])
        }
        favoritesList = favoritesList.sorted(by: <)
        if favoritesList.count == 0 { favoritesList.append("")}
        UserDefaults.standard.set(favoritesList, forKey: "FavoriteList")
    }

    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredStocks = self.stocks.filter { stock in
            let wordsArray = searchText.split(separator: " ")
            for word in wordsArray {
                if(stock.lowercased().contains(word.lowercased())){
                    return true
                }
            }
            return false
        }
        
        if(searchText.isEmpty) { self.filteredStocks = self.stocks }
        self.tableView.reloadData()
    }
    
    //MARK: - Loading Data
    func itemsDownloaded(items: [String]) {
        stocks = items
        filteredStocks = items
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
    }
    
    func loadingStarted(){
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            destination.stockName = stocks[tableView.indexPathForSelectedRow!.row]
        }
    }
}
