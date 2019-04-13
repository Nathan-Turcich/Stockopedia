//
//  File.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/12/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import Foundation

class RealTimeStock {
    
    //MARK: - Variables
    var abbr:String!
    var fullName:String!
    var date:String!
    var open:String!
    var close:String!
    var low:String!
    var high:String!
    var volume:String!
    var mkrtCap:String!
    var diff:String!

    init(abbr: String, fullName: String, date: String, open: String, close: String, low: String, high: String, volume: String, mrktCap: String, diff: String) {
        self.abbr = abbr
        self.fullName = fullName
        self.date = date
        self.open = open
        self.close = close
        self.low = low
        self.high = high
        self.volume = volume
        self.mkrtCap = mrktCap
        self.diff = diff
    }
}
