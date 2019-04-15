//
//  RealTimeStocksViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var primaryColor:UIColor = #colorLiteral(red: 1, green: 0.50186795, blue: 0, alpha: 1)

class RealTimeStocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Variables
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var searchBarCancelButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var noStockDataLabel: UILabel!
    let activityIndicator = UIActivityIndicatorView()

    var stocks = [[RealTimeStock]]()
    var stocksArrayOnly: [RealTimeStock] = []
    var filteredStocks: [RealTimeStock] = []
    
    var sectionDic:[Int : Int] = [:]
    var sectionHeader:[Int : String] = [:]
    var isSearching:Bool = false
    var lastIndexPath:IndexPath!
    
    override func viewDidLoad() { super.viewDidLoad() }
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }

    override func viewWillAppear(_ animated: Bool) {
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        dateLabel.backgroundColor = primaryColor
        
        if let id = UserDefaults.standard.string(forKey: "currentID"), let name = UserDefaults.standard.string(forKey: "currentUsername"){
            currentID = id; currentUsername = name
        }
        else { currentID = ""; currentUsername = "" }
        
        for i in 0...25 { sectionDic[i] = 0 }
        generateSectionHeader()
        if tableView.indexPathForSelectedRow != nil { tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true) }
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.height), animated: true)
        searchBar.barTintColor = primaryColor
        
        tableView.sectionIndexColor = primaryColor
        tableView.reloadData()
        searchBarCancelButton.isEnabled = false
        searchBarCancelButton.title = ""
        loadingStarted()
        
        if currentID != "" {
            tableView.isHidden = false; tableView.isScrollEnabled = true; tableView.separatorStyle = .singleLine
            dateLabel.textColor = UIColor.white
            downloadStocks()
        }
        else {
            activityIndicator.stopAnimating()
            noStockDataLabel.isHidden = false
            tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
            dateLabel.textColor = primaryColor
        }
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionHeader[section] }
    func numberOfSections(in tableView: UITableView) -> Int { return (isSearching ? 1 : 26) }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (isSearching ? filteredStocks.count : sectionDic[section]!) }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 145 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RealTimeStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "realTimeCell") as! RealTimeStockTableViewCell
        if isSearching {
            cell.abbrLabel.text = filteredStocks[indexPath.row].abbr
            cell.fullNameLabel.text = filteredStocks[indexPath.row].fullName
            cell.openLabel.text = filteredStocks[indexPath.row].open
            cell.closeLabel.text = filteredStocks[indexPath.row].close
            cell.diffLabel.text = filteredStocks[indexPath.row].diff
            cell.arrowImage.image = (filteredStocks[indexPath.row].diff.contains("-") ? UIImage(named: "redArrow") : UIImage(named: "greenArrow"))
        }
        else {
            cell.abbrLabel.text = stocks[indexPath.section][indexPath.row].abbr
            cell.fullNameLabel.text = stocks[indexPath.section][indexPath.row].fullName
            cell.openLabel.text = stocks[indexPath.section][indexPath.row].open
            cell.closeLabel.text = stocks[indexPath.section][indexPath.row].close
            cell.diffLabel.text = stocks[indexPath.section][indexPath.row].diff
            cell.arrowImage.image = (stocks[indexPath.section][indexPath.row].diff.contains("-") ? UIImage(named: "redArrow") : UIImage(named: "greenArrow"))
        }
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    //MARK: - Search Bar Methods
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
            filteredStocks = stocksArrayOnly.filter { stock in
                let wordsArray = searchText.split(separator: " ")
                for word in wordsArray {
                    if(stock.abbr.lowercased().contains(word.lowercased())){
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
    
    //MARK: - Loading Data
    func downloadStocks(){
        DownloadData.downloadRealTimeData(completion: { s in
            if let stockArray = s { self.setData(stockArray: stockArray) }
            else { print("Error getting data") }
        })
    }
    
    func setData(stockArray: [RealTimeStock]){
        DispatchQueue.main.async {
            self.stocksArrayOnly = stockArray
            self.generateSectionDic(stockArray: stockArray)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.tableView.isHidden = false
            self.tableView.isScrollEnabled = true
            self.tableView.separatorStyle = .singleLine
            self.tableView.allowsSelection = true
            if self.lastIndexPath != nil { self.tableView.scrollToRow(at: self.lastIndexPath, at: .middle, animated: false) }
            self.dateLabel.text = "Last Updated: " + self.stocksArrayOnly[self.stocksArrayOnly.count - 1].date
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
    
    func generateSectionDic(stockArray: [RealTimeStock]){
        for _ in 0...25 {
            stocks.append([RealTimeStock.init(abbr: "", fullName: "", date: "", open: "", close: "", low: "", high: "", volume: "", mrktCap: "", diff: "")])
        }
        
        for stock in stockArray {
            switch stock.abbr.prefix(1) {
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
            var tempStocks:[RealTimeStock] = []
            for stock in stockArray {
                if stock.abbr != "" { tempStocks.append(stock) }
            }
            stocks[index] = tempStocks
        }
    }
    
    func generateSectionHeader(){
        sectionHeader = [0 : "A", 1 : "B", 2: "C", 3 : "D", 4 : "E", 5 : "F", 6 : "G", 7 : "H", 8 : "I", 9 : "J", 10 : "K", 11 : "L", 12 : "M", 13 : "N", 14 : "O", 15 : "P", 16 : "Q", 17 : "R", 18 : "S", 19 : "T", 20 : "U", 21 : "V", 22 : "W", 23 : "X", 24 : "Y", 25 : "Z"]
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "realTimeStockDetailSegue" {
            let destination = segue.destination as! RealTimeStockDetailViewController
            lastIndexPath = tableView.indexPathForSelectedRow!
            if isSearching { destination.stock = filteredStocks[tableView.indexPathForSelectedRow!.row] }
            else { destination.stock = stocks[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row] }
        }
        else { lastIndexPath = nil }
    }
}
