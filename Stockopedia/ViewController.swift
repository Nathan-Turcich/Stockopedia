//
//  ViewController.swift
//  Stockopedia
//
//  Created by Joey Chung on 3/10/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HStockProtocol {
    
    func itemsDownloaded(items: [String]) {
        stocks = items
        self.tableView.reloadData()
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    var stocks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello")
        let hstock = HStock()
        hstock.delegate = self
        hstock.downloadItems()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StockTableViewCell
        
        cell.stockNameLabel.text = stocks[indexPath.row]
        
        return cell
    }
    
    

}

