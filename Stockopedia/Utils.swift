//
//  Utils.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/28/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit
import Foundation

class Utils {
    
    static func getPossibleUser(){
        if let id = UserDefaults.standard.string(forKey: "currentID"), let name = UserDefaults.standard.string(forKey: "currentUsername"){
            currentID = id; currentUsername = name
        }
        else { currentID = ""; currentUsername = "" }
    }
    
    static func setBars(navBar: UINavigationBar, tabBar: UITabBar){
        navBar.isTranslucent = false
        navBar.barTintColor = primaryColor
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 24) as Any]
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = primaryColor
    }
    
    //Creates random string for Database purposes
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    //Creates a UIAlertView with a specific message to be displayed on a specific UIViewController
    class func createAlertWith(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Stockopedia", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
