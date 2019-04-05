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
    var abbr: String!
    var fullName: String!

    init(abbr: String, fullName: String) {
        self.abbr = abbr
        self.fullName = fullName
    }
    
    override init() {
        
    }
}
