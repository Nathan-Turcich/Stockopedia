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
    
    static func setBars(navBar: UINavigationBar, tabBar: UITabBar){
        navBar.isTranslucent = false
        navBar.barTintColor = primaryColor
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 24) as Any]
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = primaryColor
    }
}
