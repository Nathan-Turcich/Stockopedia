//
//  Stock.swift
//  Stockopedia
//
//  Created by Joey Chung on 3/10/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import Foundation

public class Stock: NSObject, URLSessionDataDelegate {

    //MARK: - Stock Variables
    var name: String!
    var date: String!
    var open: Float!
    var high: Float!
    var low: Float!
    var volume: Int!

    init(name: String, date: String, open: Float, high: Float, low: Float, volume: Int) {
        self.name = name
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.volume = volume
    }
}
