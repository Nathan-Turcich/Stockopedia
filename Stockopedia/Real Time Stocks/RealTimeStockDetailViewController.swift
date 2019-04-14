//
//  RealTimeStockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/12/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit
import Charts

class RealTimeStockDetailViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var percentDiffLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var stock:RealTimeStock!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        favoriteButton.layer.borderColor = primaryColor.cgColor; favoriteButton.layer.borderWidth = 2
    }
    
    //MARK: - Helper Functions
    func setLabels(){
        navigationItem.title = stock.abbr
        fullNameLabel.text = stock.fullName
        dateLabel.text = stock.date
        openLabel.text = "Open: " + stock.open
        closeLabel.text = "Close: " + stock.close
        lowLabel.text = "Low: " + stock.low
        highLabel.text = "High: " + stock.high
        volumeLabel.text = "Volume: " + stock.volume
        marketCapLabel.text = "Market Cap: " + stock.mkrtCap
        percentDiffLabel.backgroundColor = stock.diff.contains("-") ? .red : .green
        percentDiffLabel.text = stock.diff
    }
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        if favoriteButton.backgroundColor == UIColor.white { //Insert to User Favorite List
            DownloadData.insertNameFavoritedList(key: currentID, abbr: stock.abbr, fullName: stock.fullName)
            favoriteButton.backgroundColor = primaryColor; favoriteButton.setTitleColor(UIColor.white, for: .normal)
        }
        else { //Delete to User Favorite List
            DownloadData.deleteNameFavoritedList(key: currentID, abbr: stock.abbr)
            favoriteButton.backgroundColor = UIColor.white; favoriteButton.setTitleColor(primaryColor, for: .normal)
        }
    }
}
