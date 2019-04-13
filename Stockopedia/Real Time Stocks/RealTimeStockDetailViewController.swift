//
//  RealTimeStockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/12/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class RealTimeStockDetailViewController: UIViewController {

    //MARK: - Variables
    var stockAbbr:String!
    var stockName:String!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockAbbr
    }
}
