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
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var monthList:[String] = []
    var yearList:[String] = ["2013", "2014", "2015", "2016", "2017", "2018"]
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockName
        nameLabel.text = stockName!
        segmantControl.setEnabled(true, forSegmentAt: 0)
        DownloadData.downloadPossibleMonths(abbr: stockName, completion: { m in
            self.monthList = m!
            self.monthList.reverse()
            self.tableView.reloadData()
//            self.loadMonthlyData(month: self.monthList[0])
        })
    }
    
    //MARK: - Loading Data
    func loadMonthlyData(month: String){
        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        tableView.isHidden = true; tableView.isScrollEnabled = false
        DownloadData.downloadUniqueStockDataForMonth(abbr: stockName, month: month, completion: { val in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false; self.tableView.isScrollEnabled = true
                self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            }
        })
    }
    
    func loadYearlyData(year: String){
        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
        DownloadData.downloadUniqueStockDataForYear(abbr: stockName, year: year, completion: { val in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false; self.tableView.isScrollEnabled = true; self.tableView.separatorStyle = .singleLine
            }
        })
    }
    
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if segmantControl.isEnabledForSegment(at: 0){ loadMonthlyData(month: "Janurary") }
        else{ loadYearlyData(year: "2018") }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (segmantControl.isEnabledForSegment(at: 0) ? monthList.count : yearList.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockDetailCell") as! StockDetailTableViewCell
        if segmantControl.isEnabledForSegment(at: 0) { cell.dataLabel.text = monthList[indexPath.row] }
        else { cell.dataLabel.text = yearList[indexPath.row] }
        return cell
    }
}
