//
//  StockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit
import Charts

class StockDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var stockAbbr:String!
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var graphView: LineChartView!
    var monthList:[(numberDate: String, humanDate: String)] = []
    var yearList:[String] = ["2018", "2017", "2016", "2015", "2014", "2013"]
    var dataList:[(date: String, close: String)] = []
    var lastIndexPath:IndexPath!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockAbbr
        nameLabel.text = stockName!
        graphView.layer.borderColor = UIColor.black.cgColor;
        graphView.layer.borderWidth = 1
        lastIndexPath = IndexPath(row: 0, section: 0)
        segmantControl.setEnabled(true, forSegmentAt: 0)
        disableView()
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
        disableView()
        DownloadData.downloadUniqueStockDataForMonth(abbr: stockAbbr, month: month, completion: { data in
            DispatchQueue.main.async {
                self.dataList = data!
                self.createGraph()
                self.enableView()
            }
        })
    }
    
    func loadYearlyData(year: String){
        disableView()
        DownloadData.downloadUniqueStockDataForYear(abbr: stockAbbr, year: year, completion: { data in
            DispatchQueue.main.async {
                self.dataList = data!
                self.createGraph()
                self.enableView()
            }
        })
    }
    
    func generateMonthList(m: [String]){
        for month in m {
            self.monthList.append((month, stringToHumanDate(d: month)))
        }
        self.monthList.reverse()
    }
    
    //MARK: - Segmented Control
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        lastIndexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false)
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
        createBackgroundColor(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        if segmantControl.selectedSegmentIndex == 0 { loadMonthlyData(month: String(monthList[indexPath.row].numberDate.dropLast(3))) }
        else { loadYearlyData(year: yearList[indexPath.row]) }
    }
    
    //MARK: - Graph Methods
    func createGraph() {
        //Set up chart
        var dataEntries: [ChartDataEntry] = []
        var i = 1
        for _ in self.dataList {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(self.dataList[i - 1].close)!)
            dataEntries.append(dataEntry)
            i += 1
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Day")
        chartDataSet.setCircleColor(NSUIColor(cgColor: UIColor.clear.cgColor))
        chartDataSet.circleHoleColor = NSUIColor(cgColor: primaryColor.cgColor)
        chartDataSet.setColors(NSUIColor(cgColor: primaryColor.cgColor))
        let chartData = LineChartData(dataSet: chartDataSet)
        self.graphView.data = chartData
        self.graphView.chartDescription?.text = "Price"
    }
    
    //MARK: - Helper Functions
    func stringToHumanDate(d: String) -> String {
        let dateFormatterGet = DateFormatter(); dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter(); dateFormatterPrint.dateFormat = "YYYY - MMMM"
        return dateFormatterPrint.string(from: dateFormatterGet.date(from: d)!)
    }
    
    func disableView(){
        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
    }
    
    func enableView() {
        self.activityIndicator.stopAnimating()
        self.tableView.isHidden = false; self.tableView.isScrollEnabled = true;
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
        self.tableView.selectRow(at: self.lastIndexPath, animated: false, scrollPosition: .none)
    }
    
    fileprivate func createBackgroundColor(_ cell: StockDetailTableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = primaryColor
        cell.selectedBackgroundView = backgroundView
    }
}
