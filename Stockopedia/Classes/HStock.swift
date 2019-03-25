//
//  HStock.swift
//  Stockopedia
//
//  Created by Joey Chung on 3/10/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import Foundation

protocol HStockProtocol: class {
    func itemsDownloaded(items: [String])
}

public class HStock: NSObject, URLSessionDataDelegate {
    
    //MARK: - Variables
    weak var delegate: HStockProtocol!
    var data = Data()
    let urlPath: String = "http://sp19-cs411-49.cs.illinois.edu/service.php"
    
    //MARK: - HStock Variables
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
    
    override init() {
    }
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var stocks: [String] = []
        
        for i in 0 ..< jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            stocks.append(jsonElement["name"]! as! String)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: stocks)
        })
    }
}
