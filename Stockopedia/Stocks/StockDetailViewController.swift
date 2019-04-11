//
//  StockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var list:[String] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockName
        nameLabel.text = stockName!
        loadData()
    }
    
    //MARK: - Loading Data
    func loadData(){
        
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return list.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockDetailCell") as! StockDetailTableViewCell
        cell.dataLabel.text = list[indexPath.row]
        return cell
    }
    
}
