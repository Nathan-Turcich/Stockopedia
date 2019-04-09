//
//  RealTimeStocksViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var primaryColor:UIColor = #colorLiteral(red: 1, green: 0.50186795, blue: 0, alpha: 1)

class RealTimeStocksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    @IBOutlet var tableView: UITableView!
    var stocks: [String] = []
    @IBOutlet weak var noStockDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableDisableTableView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return stocks.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RealTimeStockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "realTimeCell") as! RealTimeStockTableViewCell
        cell.stockNameLabel.text = stocks[indexPath.row]
        return cell
    }
    
    func enableDisableTableView(){
        if stocks.count != 0 {
            tableView.isHidden = false
            tableView.isScrollEnabled = true
            tableView.rowHeight = 30
            tableView.separatorStyle = .singleLine
            tableView.allowsSelection = true
            tableView.reloadData()
            noStockDataLabel.isHidden = true
        }
        else {
            tableView.isHidden = true
            tableView.isScrollEnabled = false
            noStockDataLabel.isHidden = false
        }
    }
}
