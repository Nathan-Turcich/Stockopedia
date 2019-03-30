//
//  DownloadData.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/29/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import Foundation

var urlPath:String = "http://sp19-cs411-49.cs.illinois.edu/queries.php"

class DownloadData {
    
    static func downloadUniqueStockNames(completion:@escaping ([String]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=get_all_stock_names")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var stocks: [String] = []
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    stocks.append(jsonElement["name"]! as! String)
                }
                completion(stocks)
            }
        }
        task.resume()
    }
    
    static func downloadFavoritedList(completion:@escaping ([String]?) -> Void) {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var stocks: [String] = []
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    stocks.append(jsonElement["name"]! as! String)
                }
                completion(stocks)
            }
        }
        task.resume()
    }
    
    static func createNewUser(username: String, password: String) {
        let key = Utils.randomString(length: 15)
        let  url: URL = URL(string: urlPath + "?query=create_user&key=" + key + "&username=" + username + "&password=" + password)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    static func getUser(key: String, completion:@escaping ([String]?) -> Void) {
        let url: URL = URL(string: urlPath + "/?query=get_user&key=" + key)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                /*var jsonElement = NSDictionary()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    stocks.append(jsonElement["name"]! as! String)
                }
                completion(stocks)*/
            }
        }
        task.resume()
    }
    
}
