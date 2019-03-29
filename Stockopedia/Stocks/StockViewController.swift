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
    var sectionDic:[Int : Int] = [:]
    var sectionHeader:[Int : String] = [:]
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        for i in 0...25 { sectionDic[i] = 0 }
        generateSectionHeader()
        hstock.delegate = self
        hstock.downloadItems()
        loadingStarted()
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableView.indexPathForSelectedRow != nil { tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true) }
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.height), animated: true)
        favoritesList = UserDefaults.standard.stringArray(forKey: "FavoriteList") ?? [""]
        tableView.sectionIndexColor = primaryColor
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionHeader[section] }
    func numberOfSections(in tableView: UITableView) -> Int { return 26 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sectionDic[section]!)
        return sectionDic[section]!
//        return filteredStocks.count
    }
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
        generateSectionDic()
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
    
    func generateSectionDic(){
        for stock in stocks {
            switch stock.prefix(1) {
            case "A": sectionDic[0] = sectionDic[0]! + 1
            case "B": sectionDic[1] = sectionDic[1]! + 1
            case "C": sectionDic[2] = sectionDic[2]! + 1
            case "D": sectionDic[3] = sectionDic[3]! + 1
            case "E": sectionDic[4] = sectionDic[4]! + 1
            case "F": sectionDic[5] = sectionDic[5]! + 1
            case "G": sectionDic[6] = sectionDic[6]! + 1
            case "H": sectionDic[7] = sectionDic[7]! + 1
            case "I": sectionDic[8] = sectionDic[8]! + 1
            case "J": sectionDic[9] = sectionDic[9]! + 1
            case "K": sectionDic[10] = sectionDic[10]! + 1
            case "L": sectionDic[11] = sectionDic[11]! + 1
            case "M": sectionDic[12] = sectionDic[12]! + 1
            case "N": sectionDic[13] = sectionDic[13]! + 1
            case "O": sectionDic[14] = sectionDic[14]! + 1
            case "P": sectionDic[15] = sectionDic[15]! + 1
            case "Q": sectionDic[16] = sectionDic[16]! + 1
            case "R": sectionDic[17] = sectionDic[17]! + 1
            case "S": sectionDic[18] = sectionDic[18]! + 1
            case "T": sectionDic[19] = sectionDic[19]! + 1
            case "U": sectionDic[20] = sectionDic[20]! + 1
            case "V": sectionDic[21] = sectionDic[21]! + 1
            case "W": sectionDic[22] = sectionDic[22]! + 1
            case "X": sectionDic[23] = sectionDic[23]! + 1
            case "Y": sectionDic[24] = sectionDic[24]! + 1
            case "Z": sectionDic[25] = sectionDic[25]! + 1
            default: print("") }
        }
    }
    
    func generateSectionHeader(){
        sectionHeader = [0 : "A", 1 : "B", 2: "C", 3 : "D", 4 : "E", 5 : "F", 6 : "G", 7 : "H", 8 : "I", 9 : "J", 10 : "K", 11 : "L", 12 : "M", 13 : "N", 14 : "O", 15 : "P", 16 : "Q", 17 : "R", 18 : "S", 19 : "T", 20 : "U", 21 : "V", 22 : "W", 23 : "X", 24 : "Y", 25 : "Z"]
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            destination.stockName = stocks[tableView.indexPathForSelectedRow!.row]
        }
    }
}
