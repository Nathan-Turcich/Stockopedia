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
    @IBOutlet var loginView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        setView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    @IBAction func logOutButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.set("", forKey: "CurrentUser")
            currentUserID = ""
            self.setView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func setView(){
        if(currentUserID == "") {
            loginView.isHidden = false
            profileView.isHidden = true
            self.logoutButton.title = ""
            self.logoutButton.isEnabled = false
        }else{
            loginView.isHidden = true
            profileView.isHidden = false
            self.logoutButton.title = "Logout"
            self.logoutButton.isEnabled = true
        }
    }
}
