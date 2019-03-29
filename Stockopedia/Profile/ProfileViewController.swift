//
//  ProfileViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }

}
