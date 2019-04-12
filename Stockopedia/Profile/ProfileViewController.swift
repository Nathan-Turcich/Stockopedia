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
    @IBOutlet weak var recommendationsButton: UIButton!
    @IBOutlet weak var buySellButton: UIButton!
    @IBOutlet var profileView: UIView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!

    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utils.setBars(navBar: (navigationController?.navigationBar)!, tabBar: (tabBarController?.tabBar)!)
        if let id = UserDefaults.standard.string(forKey: "currentID"), let name = UserDefaults.standard.string(forKey: "currentUsername"){
            currentID = id; currentUsername = name
        }
        else { currentID = ""; currentUsername = "" }
        setView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .lightContent }
    
    @IBAction func logOutButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "currentID")
            UserDefaults.standard.removeObject(forKey: "currentUsername")
            currentID = ""
            currentUsername = ""
            self.setView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    func setView(){
        if(currentID == "") {
            loginView.isHidden = false
            profileView.isHidden = true
            self.logoutButton.title = ""
            self.logoutButton.isEnabled = false
        }else{
            usernameLabel.text = "Logged in as: " + currentUsername
            loginView.isHidden = true
            profileView.isHidden = false
            self.logoutButton.title = "Logout"
            self.logoutButton.isEnabled = true
        }
    }
    
    func setUpButtons() {
        recommendationsButton.layer.borderColor = UIColor.black.cgColor; recommendationsButton.layer.borderWidth = 1
        buySellButton.layer.borderColor = UIColor.black.cgColor; buySellButton.layer.borderWidth = 1
        changeUserNameButton.layer.borderColor = UIColor.black.cgColor; changeUserNameButton.layer.borderWidth = 1
        changePasswordButton.layer.borderColor = UIColor.black.cgColor; changePasswordButton.layer.borderWidth = 1
    }
}
