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
    var stockAbbr:String!
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var monthList:[(numberDate: String, humanDate: String)] = []
    var yearList:[String] = ["2018", "2017", "2016", "2015", "2014", "2013"]
    var dataList:[String] = []
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockAbbr
        nameLabel.text = stockName!
        graphView.layer.borderColor = UIColor.black.cgColor; graphView.layer.borderWidth = 1
        segmantControl.setEnabled(true, forSegmentAt: 0)
        DownloadData.downloadPossibleMonths(abbr: stockAbbr, completion: { m in
            DispatchQueue.main.async {
                self.generateMonthList(m: m!)
                self.tableView.reloadData()
                self.loadMonthlyData(month: String(self.monthList[0].numberDate.dropLast(3)))
            }
        })
    }
    
    //MARK: - Loading Data
    func loadMonthlyData(month: String){
        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
        DownloadData.downloadUniqueStockDataForMonth(abbr: stockAbbr, month: month, completion: { data in
            DispatchQueue.main.async {
                self.dataList = data!
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false; self.tableView.isScrollEnabled = true; self.tableView.separatorStyle = .singleLine
                self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            }
        })
    }
    
    func loadYearlyData(year: String){
//        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
//        tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
//        DownloadData.downloadUniqueStockDataForYear(abbr: stockAbbr, year: year, completion: { val in
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//                self.tableView.isHidden = false; self.tableView.isScrollEnabled = true; self.tableView.separatorStyle = .singleLine
//                self.tableView.reloadData()
//            }
//        })
//        self.tableView.reloadData()
    }
    
    func generateMonthList(m: [String]){
        for month in m {
            self.monthList.append((month, stringToHumanDate(d: month)))
        }
        self.monthList.reverse()
    }
    
    //MARK: - Segmented Control
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        if segmantControl.selectedSegmentIndex == 0 { loadMonthlyData(month: String(monthList[0].numberDate.dropLast(3))) }
        else{ loadYearlyData(year: yearList[0]) }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmantControl.selectedSegmentIndex == 0 { return monthList.count }
        else { return yearList.count }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockDetailCell") as! StockDetailTableViewCell
        if segmantControl.selectedSegmentIndex == 0 { cell.dataLabel.text = monthList[indexPath.row].humanDate }
        else { cell.dataLabel.text = yearList[indexPath.row] }
        return cell
    }
    
    //MARK: - Helper Functions
    func stringToHumanDate(d: String) -> String {
        let dateFormatterGet = DateFormatter(); dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter(); dateFormatterPrint.dateFormat = "YYYY-MMMM"
        return dateFormatterPrint.string(from: dateFormatterGet.date(from: d)!)
    }
}
