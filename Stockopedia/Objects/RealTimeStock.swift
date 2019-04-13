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
    var open:String!
    var close:String!
    var diff:String!
    var date:String!
    
    init(a: String, fn: String, o: String, c: String, d: String, date: String) {
        self.abbr = a
        self.fullName = fn
        self.open = o
        self.close = c
        self.diff = d
        self.date = date
    }
}
