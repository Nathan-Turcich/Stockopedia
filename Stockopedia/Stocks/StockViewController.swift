//
//  StockViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var favoritedList:[String] = []

class StockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StockCellDelegate {
    
    //MARK: - Variables
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var searchBarCancelButton: UIBarButtonItem!
    
    var stocks = [[String]]()
    var listOfStocks: [String] = []
    var filteredStocks: [String] = []
    var sectionDic:[Int : Int] = [:]
    var sectionHeader:[Int : String] = [:]
    var isSearching:Bool = false
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        for i in 0...25 { sectionDic[i] = 0 }
        generateSectionHeader()
        searchBar.barTintColor = primaryColor
        
        loadingStarted()
        downloadStocks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableView.indexPathForSelectedRow != nil { tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true) }
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.height), animated: true)
        tableView.sectionIndexColor = primaryColor
        tableView.reloadData()
        searchBarCancelButton.isEnabled = false
        searchBarCancelButton.title = ""
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionHeader[section] }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching { return 1 }
        else { return 26 }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return filteredStocks.count }
        else { return sectionDic[section]! }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "allStocksCell") as! StockTableViewCell
        if isSearching { cell.stockNameLabel.text = filteredStocks[indexPath.row] }
        else { cell.stockNameLabel.text = stocks[indexPath.section][indexPath.row] }
        if currentUserID != "" {
            cell.favoriteButton.isHidden = false; cell.favoriteButton.isEnabled = true
            if isSearching {
                if favoritedList.contains(filteredStocks[indexPath.row]) {
                    cell.favoriteButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)
                }
                else { cell.favoriteButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}
            }
            else{
                if favoritedList.contains(listOfStocks[indexPath.row]) {
                    cell.favoriteButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)
                }
                else { cell.favoriteButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}
            }
        }
        else { cell.favoriteButton.isHidden = true; cell.favoriteButton.isEnabled = false }
        cell.delegate = self
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchBarCancelButton.isEnabled = false
            searchBarCancelButton.title = ""
        }
        else{
            isSearching = true
            searchBarCancelButton.isEnabled = true
            searchBarCancelButton.title = "Cancel"
            filteredStocks = listOfStocks.filter { stock in
                let wordsArray = searchText.split(separator: " ")
                for word in wordsArray {
                    if(stock.lowercased().contains(word.lowercased())){
                        return true
                    }
                }
                return false
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarCancelButton.isEnabled = true
        searchBarCancelButton.title = "Cancel"
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarCancelButton.isEnabled = false
        searchBarCancelButton.title = ""
    }
    @IBAction func searchBarCancelButton(_ sender: Any) {
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.height), animated: true)
        searchBar.text = nil
        searchBar.endEditing(true)
        isSearching = false
        tableView.reloadData()
    }
    
    func btnCloseTapped(cell: StockTableViewCell) {
        if cell.favoriteButton.currentImage == UIImage(named: "favoritesFilled") {
            UIView.transition(with: cell.favoriteButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favoriteButton.setImage(UIImage(named: "favoritesNotFilled"), for: .normal)}, completion: (nil))
            DownloadData.deleteNameFavoritedList(key: currentUserID, name: cell.stockNameLabel.text!)
        }
        else{
            UIView.transition(with: cell.favoriteButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                cell.favoriteButton.setImage(UIImage(named: "favoritesFilled"), for: .normal)}, completion: (nil))
            DownloadData.insertNameFavoritedList(key: currentUserID, name: cell.stockNameLabel.text!)
        }
        DownloadData.downloadFavoritedList(key: currentUserID, completion: { list in
            favoritedList = list!
        })
    }
    
    //MARK: - Loading Data
    func downloadStocks(){
        DownloadData.downloadUniqueStockNames(completion: { stockNames in
            if let names = stockNames {
                if currentUserID != "" {
                    DownloadData.getUserFavoritedList(key: currentUserID, completion: { (favList) in
                        favoritedList = favList!
                        self.setData(names: names)
                    })
                }
                else { self.setData(names: names)}
            }
            else { print("Error getting data") }
        })
    }
    
    func setData(names: [String]){
        DispatchQueue.main.async {
            self.listOfStocks = names
            self.generateSectionDic(items: names)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.tableView.isHidden = false
            self.tableView.isScrollEnabled = true
            self.tableView.separatorStyle = .singleLine
            self.tableView.allowsSelection = true
        }
    }
    
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
    
    func generateSectionDic(items: [String]){
        for _ in 0...25 { stocks.append(["!"]) }

        for stock in items {
            switch stock.prefix(1) {
            case "A":
                sectionDic[0] = sectionDic[0]! + 1
                stocks[0].append(stock)
            case "B":
                sectionDic[1] = sectionDic[1]! + 1
                stocks[1].append(stock)
            case "C":
                sectionDic[2] = sectionDic[2]! + 1
                stocks[2].append(stock)
            case "D":
                sectionDic[3] = sectionDic[3]! + 1
                stocks[3].append(stock)
            case "E":
                sectionDic[4] = sectionDic[4]! + 1
                stocks[4].append(stock)
            case "F":
                sectionDic[5] = sectionDic[5]! + 1
                stocks[5].append(stock)
            case "G":
                sectionDic[6] = sectionDic[6]! + 1
                stocks[6].append(stock)
            case "H":
                sectionDic[7] = sectionDic[7]! + 1
                stocks[7].append(stock)
            case "I":
                sectionDic[8] = sectionDic[8]! + 1
                stocks[8].append(stock)
            case "J":
                sectionDic[9] = sectionDic[9]! + 1
                stocks[9].append(stock)
            case "K":
                sectionDic[10] = sectionDic[10]! + 1
                stocks[10].append(stock)
            case "L":
                sectionDic[11] = sectionDic[11]! + 1
                stocks[11].append(stock)
            case "M":
                sectionDic[12] = sectionDic[12]! + 1
                stocks[12].append(stock)
            case "N":
                sectionDic[13] = sectionDic[13]! + 1
                stocks[13].append(stock)
            case "O":
                sectionDic[14] = sectionDic[14]! + 1
                stocks[14].append(stock)
            case "P":
                sectionDic[15] = sectionDic[15]! + 1
                stocks[15].append(stock)
            case "Q":
                sectionDic[16] = sectionDic[16]! + 1
                stocks[16].append(stock)
            case "R":
                sectionDic[17] = sectionDic[17]! + 1
                stocks[17].append(stock)
            case "S":
                sectionDic[18] = sectionDic[18]! + 1
                stocks[18].append(stock)
            case "T":
                sectionDic[19] = sectionDic[19]! + 1
                stocks[19].append(stock)
            case "U":
                sectionDic[20] = sectionDic[20]! + 1
                stocks[20].append(stock)
            case "V":
                sectionDic[21] = sectionDic[21]! + 1
                stocks[21].append(stock)
            case "W":
                sectionDic[22] = sectionDic[22]! + 1
                stocks[22].append(stock)
            case "X":
                sectionDic[23] = sectionDic[23]! + 1
                stocks[23].append(stock)
            case "Y":
                sectionDic[24] = sectionDic[24]! + 1
                stocks[24].append(stock)
            case "Z":
                sectionDic[25] = sectionDic[25]! + 1
                stocks[25].append(stock)
            default: print("") }
        }
        
        for (index, stockArray) in stocks.enumerated() {
            var tempStocks:[String] = []
            for stock in stockArray {
                if stock != "!" { tempStocks.append(stock) }
            }
            stocks[index] = tempStocks
        }
    }
    
    func generateSectionHeader(){
        sectionHeader = [0 : "A", 1 : "B", 2: "C", 3 : "D", 4 : "E", 5 : "F", 6 : "G", 7 : "H", 8 : "I", 9 : "J", 10 : "K", 11 : "L", 12 : "M", 13 : "N", 14 : "O", 15 : "P", 16 : "Q", 17 : "R", 18 : "S", 19 : "T", 20 : "U", 21 : "V", 22 : "W", 23 : "X", 24 : "Y", 25 : "Z"]
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stockDetailSegue" {
            let destination = segue.destination as! StockDetailViewController
            if isSearching { destination.stockName = filteredStocks[tableView.indexPathForSelectedRow!.row] }
            else{ destination.stockName = stocks[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row] }
        }
    }
}
