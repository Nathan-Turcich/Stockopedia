//
//  HistoricalStocksViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HStockProtocol{
    
    //MARK: - Variables
    @IBOutlet var tableView: UITableView!
    var stocks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let hstock = HStock()
        hstock.delegate = self
        hstock.downloadItems()
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return stocks.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoricalStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "allStocksCell") as! HistoricalStockTableViewCell
        cell.stockNameLabel.text = stocks[indexPath.row]
        return cell
    }
    
    func itemsDownloaded(items: [String]) {
        stocks = items
        stocks.append("Hello")
        self.tableView.reloadData()
    }
}
